import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_path_resolver.dart';
import 'core_process_manager.dart';
import 'core_log_manager.dart';
import 'core_status.dart';
import '../config/config_validator.dart';
import '../ipc/clash_api_client.dart';
import '../ipc/core_event_bus.dart';
import '../platform/platform_permission.dart';
import '../singbox/singbox_config_builder.dart';
import '../../models/node/node.dart';
import '../../models/group/node_group.dart';
import '../../models/route/route_rule.dart';

/// 核心管理器 - 顶层编排器
/// 统一管理核心的完整生命周期：
/// 1. 路径解析
/// 2. 权限检查
/// 3. 配置生成与验证
/// 4. 进程启动/停止/重启
/// 5. IPC 通信
/// 6. 日志管理
/// 7. 事件分发
class CoreManager extends StateNotifier<CoreStatus> {
  final CorePathResolver pathResolver;
  final CoreLogManager logManager;
  final CoreEventBus eventBus;
  final RuntimeConfigManager configManager;
  final PlatformPermission permission;
  late final CoreProcessManager _processManager;
  ClashApiClient? _apiClient;
  Timer? _apiPollTimer;
  VoidCallback? _processListenerRemover;

  // Clash API 配置
  String _apiHost = '127.0.0.1';
  int _apiPort = 9090;
  String? _apiSecret;

  CoreManager({
    CorePathResolver? pathResolver,
    CoreLogManager? logManager,
    CoreEventBus? eventBus,
    PlatformPermission? permission,
  })  : pathResolver = pathResolver ?? CorePathResolver.instance,
        logManager = logManager ?? CoreLogManager(),
        eventBus = eventBus ?? CoreEventBus.instance,
        permission = permission ?? PlatformPermission.instance,
        configManager = RuntimeConfigManager(
          pathResolver ?? CorePathResolver.instance,
        ),
        super(const CoreStatus()) {
    _processManager = CoreProcessManager(
      pathResolver: this.pathResolver,
      logManager: this.logManager,
    );

    // 监听进程状态变化
    _processListenerRemover =
        _processManager.addListener(_onProcessStatusChanged);
  }

  /// Clash API 客户端
  ClashApiClient? get apiClient => _apiClient;

  /// 日志流
  Stream<LogEntry> get logStream => logManager.logStream;

  /// 核心原始输出流
  Stream<String> get rawLogStream => logManager.rawStream;

  /// 所有缓存日志
  List<LogEntry> get logs => logManager.logs;

  /// 设置 Clash API 参数
  void configureApi({String? host, int? port, String? secret}) {
    if (host != null) _apiHost = host;
    if (port != null) _apiPort = port;
    _apiSecret = secret;
  }

  /// 启动核心的完整流程
  /// 1. 检查权限
  /// 2. 生成配置
  /// 3. 验证配置
  /// 4. 启动进程
  /// 5. 等待 API 就绪
  /// 6. 连接 API
  Future<CoreStartResult> start({
    required List<Node> nodes,
    required List<NodeGroup> groups,
    required List<RouteRule> routeRules,
    String proxyMode = 'rule',
    String? selectedNodeId,
    bool enableTun = false,
    bool enableSystemProxy = true,
    String logLevel = 'info',
  }) async {
    if (state.isRunning) {
      return CoreStartResult.alreadyRunning();
    }

    state = state.copyWith(phase: CorePhase.starting);
    logManager.addSystemLog(LogLevel.info, '开始启动核心...');

    // 1. 权限检查
    final permResult = await permission.checkCorePermissions(pathResolver);
    if (!permResult.isGranted) {
      logManager.addSystemLog(LogLevel.warning, '权限不足: ${permResult.message}');
      // 尝试自动修复
      final fixed = await permission.fixPermissions(pathResolver);
      if (!fixed) {
        final error = '权限不足且无法自动修复: ${permResult.message}';
        state = state.copyWith(phase: CorePhase.error, errorMessage: error);
        eventBus.emitPermissionRequired(permResult.message);
        return CoreStartResult.failure(error);
      }
      logManager.addSystemLog(LogLevel.info, '权限已自动修复');
    }

    // 1.5 TUN 权限检查
    if (enableTun) {
      final tunPerm = await permission.checkTunPermission();
      if (!tunPerm.isGranted) {
        logManager.addSystemLog(
          LogLevel.warning,
          'TUN 权限: ${tunPerm.message}',
        );
        // TUN 权限不阻止启动，但记录警告
      }
    }

    // 2. 生成运行时配置
    final config = SingBoxConfigBuilder(
      nodes: nodes,
      groups: groups,
      routeRules: routeRules,
      proxyMode: proxyMode,
      selectedNodeId: selectedNodeId,
      enableTun: enableTun,
      enableSystemProxy: enableSystemProxy,
      logLevel: logLevel,
      clashApiPort: _apiPort.toString(),
    ).build();

    // 注入 Clash API experimental 配置
    config['experimental'] = {
      'clash_api': {
        'external_controller': '$_apiHost:$_apiPort',
        if (_apiSecret != null) 'secret': _apiSecret,
      },
      'cache_file': {
        'enabled': true,
      },
    };

    // 3. 写入并验证配置
    final writeResult = await configManager.writeAndValidate(config);
    if (!writeResult.validation.valid) {
      final error = '配置验证失败: ${writeResult.validation.summary}';
      state = state.copyWith(phase: CorePhase.error, errorMessage: error);
      eventBus.emitConfigError(writeResult.validation.summary);
      logManager.addSystemLog(LogLevel.error, error);
      for (final e in writeResult.validation.errors) {
        logManager.addSystemLog(LogLevel.error, '  - $e');
      }
      return CoreStartResult.failure(error);
    }

    for (final w in writeResult.validation.warnings) {
      logManager.addSystemLog(LogLevel.warning, '配置警告: $w');
    }

    eventBus.emitConfigLoaded();

    // 4. 启动进程
    final startResult = await _processManager.start(
      configPath: writeResult.path,
    );

    if (!startResult.success) {
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: startResult.error,
      );
      return startResult;
    }

    // 5. 等待 API 就绪并连接
    await _connectApi();

    // 6. 更新状态
    state = _processManager.state;
    eventBus.emitStarted(pid: state.pid);

    return startResult;
  }

  /// 使用现有配置路径直接启动（跳过配置生成）
  Future<CoreStartResult> startWithConfig(String configPath) async {
    if (state.isRunning) return CoreStartResult.alreadyRunning();

    state = state.copyWith(phase: CorePhase.starting);

    // 验证配置
    final validation = await configManager.validator.validate(configPath);
    if (!validation.valid) {
      final error = '配置验证失败: ${validation.summary}';
      state = state.copyWith(phase: CorePhase.error, errorMessage: error);
      return CoreStartResult.failure(error);
    }

    // 启动
    final result = await _processManager.start(configPath: configPath);
    if (result.success) {
      await _connectApi();
      state = _processManager.state;
      eventBus.emitStarted(pid: state.pid);
    } else {
      state = state.copyWith(
        phase: CorePhase.error,
        errorMessage: result.error,
      );
    }
    return result;
  }

  /// 停止核心
  Future<void> stop() async {
    logManager.addSystemLog(LogLevel.info, '停止核心...');
    _disconnectApi();
    await _processManager.stop();
    state = const CoreStatus(phase: CorePhase.stopped);
    eventBus.emitStopped();
  }

  /// 重启核心（使用新配置参数）
  Future<CoreStartResult> restart({
    required List<Node> nodes,
    required List<NodeGroup> groups,
    required List<RouteRule> routeRules,
    String proxyMode = 'rule',
    String? selectedNodeId,
    bool enableTun = false,
    bool enableSystemProxy = true,
    String logLevel = 'info',
  }) async {
    await stop();
    await Future.delayed(const Duration(milliseconds: 300));
    return start(
      nodes: nodes,
      groups: groups,
      routeRules: routeRules,
      proxyMode: proxyMode,
      selectedNodeId: selectedNodeId,
      enableTun: enableTun,
      enableSystemProxy: enableSystemProxy,
      logLevel: logLevel,
    );
  }

  /// 简单重启（保持当前配置）
  Future<CoreStartResult> simpleRestart() async {
    logManager.addSystemLog(LogLevel.info, '重启核心...');
    _disconnectApi();
    final result = await _processManager.restart();
    if (result.success) {
      await _connectApi();
      state = _processManager.state;
      eventBus.emitStarted(pid: state.pid);
    }
    return result;
  }

  /// 切换代理节点（通过 Clash API 热切换）
  Future<bool> selectProxy(String groupName, String proxyName) async {
    if (_apiClient == null) return false;
    return _apiClient!.selectProxy(groupName, proxyName);
  }

  /// 测试节点延迟
  Future<int?> testDelay(String proxyName, {String? testUrl}) async {
    if (_apiClient == null) return null;
    return _apiClient!.testProxyDelay(
      proxyName,
      testUrl: testUrl ?? 'http://www.gstatic.com/generate_204',
    );
  }

  /// 获取活跃连接
  Future<ConnectionsData?> getConnections() async {
    return _apiClient?.getConnections();
  }

  /// 关闭连接
  Future<bool> closeConnection(String id) async {
    return _apiClient?.closeConnection(id) ?? false;
  }

  /// 获取代理组
  Future<Map<String, ProxyGroup>?> getProxies() async {
    return _apiClient?.getProxies();
  }

  /// 获取内存使用
  Future<int?> getMemoryUsage() async {
    return _apiClient?.getMemory();
  }

  /// 导出日志
  String exportLogs() => logManager.exportAsText();

  /// 清除日志
  void clearLogs() => logManager.clear();

  /// 诊断信息
  Future<Map<String, dynamic>> getDiagnostics() async {
    final corePath = await pathResolver.resolve();
    final coreVersion = await pathResolver.getCoreVersion();
    final permCheck = await permission.checkCorePermissions(pathResolver);

    return {
      'core_path': corePath,
      'core_exists': corePath != null && File(corePath).existsSync(),
      'core_version': coreVersion,
      'permission_status': permCheck.status.name,
      'permission_message': permCheck.message,
      'api_available': _apiClient != null && await _apiClient!.isAvailable(),
      'api_endpoint': '$_apiHost:$_apiPort',
      'process_pid': state.pid,
      'status': state.phase.name,
      'uptime': state.uptime?.inSeconds,
      'log_count': logManager.logCount,
      'platform': Platform.operatingSystem,
      'platform_hint': permission.platformHint,
    };
  }

  // --- 内部方法 ---

  Future<void> _connectApi() async {
    _apiClient = ClashApiClient(
      host: _apiHost,
      port: _apiPort,
      secret: _apiSecret,
    );

    // 等待 API 就绪
    final ready = await _apiClient!.waitForReady(
      timeout: const Duration(seconds: 8),
    );
    if (ready) {
      logManager.addSystemLog(LogLevel.info, 'Clash API 已连接');
    } else {
      logManager.addSystemLog(
        LogLevel.warning,
        'Clash API 连接超时，部分功能可能不可用',
      );
    }
  }

  void _disconnectApi() {
    _apiPollTimer?.cancel();
    _apiPollTimer = null;
    _apiClient?.dispose();
    _apiClient = null;
  }

  void _onProcessStatusChanged(CoreStatus processState) {
    state = processState;

    if (processState.isCrashed) {
      eventBus.emitCrashed(error: processState.errorMessage);
      _disconnectApi();
    }
  }

  @override
  void dispose() {
    _processListenerRemover?.call();
    _disconnectApi();
    _processManager.dispose();
    logManager.dispose();
    super.dispose();
  }
}

// === Riverpod Providers ===

/// 核心管理器 Provider
final coreManagerProvider = StateNotifierProvider<CoreManager, CoreStatus>(
  (ref) => CoreManager(),
);

/// 核心日志流 Provider
final coreLogStreamProvider = StreamProvider<LogEntry>((ref) {
  final manager = ref.watch(coreManagerProvider.notifier);
  return manager.logStream;
});

/// 核心日志列表 Provider
final coreLogsProvider = Provider<List<LogEntry>>((ref) {
  // 监听最新日志以触发更新
  ref.watch(coreLogStreamProvider);
  final manager = ref.read(coreManagerProvider.notifier);
  return manager.logs;
});

/// Clash API 流量流 Provider
final coreTrafficStreamProvider = StreamProvider<TrafficData>((ref) {
  final manager = ref.watch(coreManagerProvider.notifier);
  final client = manager.apiClient;
  if (client == null) return const Stream.empty();
  return client.trafficStream();
});

/// 核心诊断信息 Provider
final coreDiagnosticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final manager = ref.read(coreManagerProvider.notifier);
  return manager.getDiagnostics();
});
