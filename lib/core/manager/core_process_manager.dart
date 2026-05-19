import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'core_path_resolver.dart';
import 'core_log_manager.dart';
import 'core_status.dart';

final _logger = Logger();

/// 核心进程管理器
/// 负责 sing-box 进程的启动、停止、重启、健康检查
class CoreProcessManager extends StateNotifier<CoreStatus> {
  final CorePathResolver _pathResolver;
  final CoreLogManager _logManager;

  Process? _process;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;
  Timer? _healthCheckTimer;
  String? _currentConfigPath;
  int _restartCount = 0;
  static const _maxAutoRestart = 3;
  static const _healthCheckInterval = Duration(seconds: 5);

  CoreProcessManager({
    required CorePathResolver pathResolver,
    required CoreLogManager logManager,
  })  : _pathResolver = pathResolver,
        _logManager = logManager,
        super(const CoreStatus());

  /// 当前进程 PID
  int? get pid => _process?.pid;

  /// 是否可以自动重启
  bool get canAutoRestart => _restartCount < _maxAutoRestart;

  /// 启动核心
  Future<CoreStartResult> start({
    required String configPath,
    List<String> extraArgs = const [],
  }) async {
    if (state.isRunning) {
      return CoreStartResult.alreadyRunning();
    }

    state = state.copyWith(
      phase: CorePhase.starting,
      errorMessage: null,
    );

    // 1. 检查核心文件
    final binaryPath = await _pathResolver.resolve();
    if (binaryPath == null) {
      final error = '未找到 sing-box 核心文件，请检查安装完整性';
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: error,
      );
      _logManager.addSystemLog(LogLevel.error, error);
      return CoreStartResult.failure(error);
    }

    // 2. 检查执行权限
    if (!Platform.isWindows) {
      final hasPermission = await _pathResolver.hasExecutePermission();
      if (!hasPermission) {
        _logManager.addSystemLog(LogLevel.warning, '核心文件无执行权限，尝试设置...');
        final set = await _pathResolver.setExecutePermission();
        if (!set) {
          const error = '无法设置核心执行权限，请手动执行: chmod +x <path>';
          state = state.copyWith(
            phase: CorePhase.error,
            errorMessage: error,
          );
          _logManager.addSystemLog(LogLevel.error, error);
          return CoreStartResult.failure(error);
        }
      }
    }

    // 3. 检查配置文件
    if (!File(configPath).existsSync()) {
      const error = '运行时配置文件不存在';
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: error,
      );
      _logManager.addSystemLog(LogLevel.error, error);
      return CoreStartResult.failure(error);
    }

    _currentConfigPath = configPath;

    // 4. 启动进程
    try {
      final workDir = await _pathResolver.getWorkingDirectory();
      final args = ['run', '-c', configPath, ...extraArgs];

      _logManager.addSystemLog(
        LogLevel.info,
        '启动核心: $binaryPath ${args.join(" ")}',
      );

      _process = await Process.start(
        binaryPath,
        args,
        workingDirectory: workDir,
        environment: _buildEnvironment(),
      );

      // 5. 监听输出
      _stdoutSub = _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_onStdout);

      _stderrSub = _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_onStderr);

      // 6. 监听进程退出
      _process!.exitCode.then(_onProcessExit);

      // 7. 等待启动确认
      final started = await _waitForStartup();
      if (!started) {
        const error = '核心启动超时，请检查配置和日志';
        state = state.copyWith(
          phase: CorePhase.error,
          errorMessage: error,
        );
        await _killProcess();
        return CoreStartResult.failure(error);
      }

      // 8. 启动成功
      state = state.copyWith(
        phase: CorePhase.running,
        startTime: DateTime.now(),
        pid: _process?.pid,
        coreVersion: await _pathResolver.getCoreVersion(),
      );
      _restartCount = 0;
      _startHealthCheck();

      _logManager.addSystemLog(
        LogLevel.info,
        '核心启动成功 (PID: ${_process?.pid})',
      );

      return CoreStartResult.success();
    } catch (e, stack) {
      final error = '启动核心异常: $e';
      _logger.e(error, error: e, stackTrace: stack);
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: error,
      );
      _logManager.addSystemLog(LogLevel.error, error);
      return CoreStartResult.failure(error);
    }
  }

  /// 停止核心
  Future<void> stop() async {
    if (state.isStopped) return;

    state = state.copyWith(phase: CorePhase.stopping);
    _stopHealthCheck();
    _logManager.addSystemLog(LogLevel.info, '正在停止核心...');

    await _cancelSubscriptions();

    if (_process != null) {
      // 优雅关闭
      try {
        _process!.kill(ProcessSignal.sigterm);
        // 等待最多 3 秒优雅退出
        final exitCode = await _process!.exitCode.timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            _logger.w('核心未在超时内退出，强制终止');
            _process!.kill(ProcessSignal.sigkill);
            return -1;
          },
        );
        _logManager.addSystemLog(
          LogLevel.info,
          '核心已停止 (exit code: $exitCode)',
        );
      } catch (e) {
        _logger.e('停止核心时出错', error: e);
        try {
          _process!.kill(ProcessSignal.sigkill);
        } catch (_) {}
      }
      _process = null;
    }

    state = const CoreStatus(phase: CorePhase.stopped);
  }

  /// 重启核心
  Future<CoreStartResult> restart({String? newConfigPath}) async {
    _logManager.addSystemLog(LogLevel.info, '重启核心...');
    await stop();
    await Future.delayed(const Duration(milliseconds: 300));

    final configPath = newConfigPath ?? _currentConfigPath;
    if (configPath == null) {
      return CoreStartResult.failure('无可用配置路径');
    }
    return start(configPath: configPath);
  }

  /// 检查配置合法性
  Future<ConfigCheckResult> checkConfig(String configPath) async {
    final binaryPath = await _pathResolver.resolve();
    if (binaryPath == null) {
      return ConfigCheckResult(valid: false, message: '未找到 sing-box 核心文件');
    }

    try {
      final result = await Process.run(
        binaryPath,
        ['check', '-c', configPath],
      );
      if (result.exitCode == 0) {
        return ConfigCheckResult(valid: true, message: '配置有效');
      }
      final stderr = (result.stderr as String).trim();
      final stdout = (result.stdout as String).trim();
      return ConfigCheckResult(
        valid: false,
        message: stderr.isNotEmpty ? stderr : stdout,
      );
    } catch (e) {
      return ConfigCheckResult(valid: false, message: '配置检查异常: $e');
    }
  }

  /// 格式化配置
  Future<String?> formatConfig(String configPath) async {
    final binaryPath = await _pathResolver.resolve();
    if (binaryPath == null) return null;

    try {
      final result = await Process.run(
        binaryPath,
        ['format', '-c', configPath],
      );
      if (result.exitCode == 0) {
        return File(configPath).readAsStringSync();
      }
    } catch (_) {}
    return null;
  }

  // --- 内部方法 ---

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);
    // 可以在这里注入额外环境变量
    return env;
  }

  Future<bool> _waitForStartup() async {
    // 等待最多 5 秒确认启动
    final completer = Completer<bool>();
    Timer? timeout;

    timeout = Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.complete(true); // 超时但进程仍在运行，假设启动成功
      }
    });

    // 检查进程是否在短时间内退出（启动失败的信号）
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (completer.isCompleted) {
        timer.cancel();
        return;
      }
      if (_process == null) {
        timer.cancel();
        timeout?.cancel();
        if (!completer.isCompleted) completer.complete(false);
      }
    });

    return completer.future;
  }

  void _startHealthCheck() {
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) {
      _checkHealth();
    });
  }

  void _stopHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
  }

  void _checkHealth() {
    if (_process == null && state.isRunning) {
      _logManager.addSystemLog(LogLevel.error, '检测到核心进程已消失');
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: '核心进程意外终止',
      );
    }
  }

  void _onStdout(String line) {
    if (line.trim().isEmpty) return;
    _logManager.addCoreLog(line);
  }

  void _onStderr(String line) {
    if (line.trim().isEmpty) return;
    _logManager.addCoreLog('[STDERR] $line', isError: true);
  }

  void _onProcessExit(int exitCode) {
    _logger.i('sing-box 进程退出, code=$exitCode');

    if (state.phase == CorePhase.stopping || state.phase == CorePhase.stopped) {
      // 正常停止
      return;
    }

    // 异常退出
    _process = null;
    _cancelSubscriptions();
    _stopHealthCheck();

    final error = '核心异常退出 (code: $exitCode)';
    _logManager.addSystemLog(LogLevel.error, error);

    state = state.copyWith(
      phase: CorePhase.crashed,
      errorMessage: error,
      lastCrashTime: DateTime.now(),
    );

    // 尝试自动重启
    if (canAutoRestart && _currentConfigPath != null) {
      _restartCount++;
      _logManager.addSystemLog(
        LogLevel.warning,
        '尝试自动重启 ($_restartCount/$_maxAutoRestart)...',
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (state.phase == CorePhase.crashed) {
          start(configPath: _currentConfigPath!);
        }
      });
    }
  }

  Future<void> _cancelSubscriptions() async {
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
  }

  Future<void> _killProcess() async {
    try {
      _process?.kill(ProcessSignal.sigkill);
    } catch (_) {}
    _process = null;
    await _cancelSubscriptions();
  }

  @override
  void dispose() {
    _stopHealthCheck();
    _killProcess();
    super.dispose();
  }
}

/// 启动结果
class CoreStartResult {
  final bool success;
  final String? error;

  CoreStartResult._(this.success, this.error);

  factory CoreStartResult.success() => CoreStartResult._(true, null);
  factory CoreStartResult.failure(String error) =>
      CoreStartResult._(false, error);
  factory CoreStartResult.alreadyRunning() =>
      CoreStartResult._(true, null);
}

/// 配置检查结果
class ConfigCheckResult {
  final bool valid;
  final String message;

  const ConfigCheckResult({required this.valid, required this.message});
}
