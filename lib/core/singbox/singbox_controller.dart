import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final _logger = Logger();

// sing-box 运行状态
enum SingBoxStatus {
  stopped,
  starting,
  running,
  stopping,
  error,
}

class SingBoxState {
  final SingBoxStatus status;
  final String? errorMessage;
  final DateTime? startTime;
  final int? pid;

  const SingBoxState({
    this.status = SingBoxStatus.stopped,
    this.errorMessage,
    this.startTime,
    this.pid,
  });

  SingBoxState copyWith({
    SingBoxStatus? status,
    String? errorMessage,
    DateTime? startTime,
    int? pid,
  }) =>
      SingBoxState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        startTime: startTime ?? this.startTime,
        pid: pid ?? this.pid,
      );

  bool get isRunning => status == SingBoxStatus.running;
  bool get isStopped => status == SingBoxStatus.stopped;
  bool get hasError => status == SingBoxStatus.error;
}

class SingBoxController extends StateNotifier<SingBoxState> {
  Process? _process;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;
  final _logController = StreamController<String>.broadcast();
  String? _configPath;

  SingBoxController() : super(const SingBoxState());

  Stream<String> get logStream => _logController.stream;

  /// 查找 sing-box 二进制路径
  Future<String?> _findBinary() async {
    // 优先使用 assets 目录下的 sing-box
    try {
      final appDir = await getApplicationSupportDirectory();
      final bundledPath = p.join(appDir.path, 'singbox', _binaryName());
      if (File(bundledPath).existsSync()) return bundledPath;
    } catch (_) {}

    // 然后查找系统 PATH
    final paths = [
      '/usr/local/bin/sing-box',
      '/usr/bin/sing-box',
      '/opt/homebrew/bin/sing-box',
      p.join(Platform.environment['HOME'] ?? '', '.local', 'bin', 'sing-box'),
    ];

    if (Platform.isWindows) {
      paths.add(r'C:\Program Files\sing-box\sing-box.exe');
    }

    for (final path in paths) {
      if (File(path).existsSync()) return path;
    }

    // 尝试 which/where
    try {
      final result = await Process.run(
        Platform.isWindows ? 'where' : 'which',
        ['sing-box'],
      );
      if (result.exitCode == 0) {
        return (result.stdout as String).trim().split('\n').first;
      }
    } catch (_) {}

    return null;
  }

  String _binaryName() {
    if (Platform.isWindows) return 'sing-box.exe';
    return 'sing-box';
  }

  /// 写出配置文件
  Future<String> _writeConfig(Map<String, dynamic> config) async {
    final appDir = await getApplicationSupportDirectory();
    final configDir = Directory(p.join(appDir.path, 'config'));
    await configDir.create(recursive: true);
    final configFile = File(p.join(configDir.path, 'config.json'));
    await configFile.writeAsString(jsonEncode(config));
    return configFile.path;
  }

  /// 启动 sing-box
  Future<void> start(Map<String, dynamic> config) async {
    if (state.isRunning) return;

    state = state.copyWith(status: SingBoxStatus.starting, errorMessage: null);

    try {
      final binaryPath = await _findBinary();
      if (binaryPath == null) {
        state = state.copyWith(
          status: SingBoxStatus.error,
          errorMessage: '未找到 sing-box 可执行文件，请在设置中指定路径',
        );
        return;
      }

      _configPath = await _writeConfig(config);
      _logger.i('Starting sing-box: $binaryPath run -c $_configPath');

      _process = await Process.start(
        binaryPath,
        ['run', '-c', _configPath!],
        runInShell: false,
      );

      _stdoutSub = _process!.stdout
          .transform(const SystemEncoding().decoder)
          .listen(_onLog);

      _stderrSub = _process!.stderr
          .transform(const SystemEncoding().decoder)
          .listen((line) => _onLog('[STDERR] $line'));

      // 等待进程启动确认
      await Future.delayed(const Duration(milliseconds: 800));
      if (_process != null) {
        state = state.copyWith(
          status: SingBoxStatus.running,
          startTime: DateTime.now(),
          pid: _process!.pid,
        );
        _logger.i('sing-box started, pid=${_process!.pid}');

        // 监听进程退出
        _process!.exitCode.then(_onProcessExit);
      }
    } catch (e) {
      _logger.e('Failed to start sing-box', error: e);
      state = state.copyWith(
        status: SingBoxStatus.error,
        errorMessage: '启动失败: $e',
      );
    }
  }

  /// 停止 sing-box
  Future<void> stop() async {
    if (state.isStopped) return;
    state = state.copyWith(status: SingBoxStatus.stopping);

    try {
      await _stdoutSub?.cancel();
      await _stderrSub?.cancel();

      if (_process != null) {
        if (Platform.isWindows) {
          _process!.kill(ProcessSignal.sigterm);
        } else {
          _process!.kill(ProcessSignal.sigterm);
          // 等待优雅关闭
          await Future.delayed(const Duration(seconds: 2));
          try {
            _process!.kill(ProcessSignal.sigkill);
          } catch (_) {}
        }
        _process = null;
      }
    } catch (e) {
      _logger.e('Error stopping sing-box', error: e);
    } finally {
      state = const SingBoxState(status: SingBoxStatus.stopped);
    }
  }

  /// 重启 sing-box
  Future<void> restart(Map<String, dynamic> config) async {
    await stop();
    await Future.delayed(const Duration(milliseconds: 500));
    await start(config);
  }

  /// 检查配置合法性
  Future<({bool valid, String message})> checkConfig(
    Map<String, dynamic> config,
  ) async {
    try {
      final binaryPath = await _findBinary();
      if (binaryPath == null) {
        return (valid: false, message: '未找到 sing-box 可执行文件');
      }

      final configPath = await _writeConfig(config);
      final result = await Process.run(binaryPath, ['check', '-c', configPath]);

      if (result.exitCode == 0) {
        return (valid: true, message: '配置合法');
      } else {
        return (
          valid: false,
          message: (result.stderr as String).trim().isNotEmpty
              ? result.stderr as String
              : result.stdout as String,
        );
      }
    } catch (e) {
      return (valid: false, message: '配置检查失败: $e');
    }
  }

  void _onLog(String data) {
    final lines = data.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      _logController.add(line);
      _logger.d('[sing-box] $line');
    }
  }

  void _onProcessExit(int exitCode) {
    _logger.w('sing-box process exited with code $exitCode');
    if (state.isRunning) {
      state = state.copyWith(
        status: exitCode == 0 ? SingBoxStatus.stopped : SingBoxStatus.error,
        errorMessage: exitCode != 0 ? 'sing-box 异常退出 (code $exitCode)' : null,
      );
    }
  }

  @override
  void dispose() {
    stop();
    _logController.close();
    super.dispose();
  }
}

final singBoxControllerProvider =
    StateNotifierProvider<SingBoxController, SingBoxState>(
  (ref) => SingBoxController(),
);
