import 'dart:async';

/// 核心事件类型
enum CoreEventType {
  started,
  stopped,
  crashed,
  configLoaded,
  configError,
  connectionChanged,
  trafficUpdate,
  logMessage,
  permissionRequired,
  coreNotFound,
  healthCheckFailed,
}

/// 核心事件
class CoreEvent {
  final CoreEventType type;
  final dynamic data;
  final DateTime timestamp;

  CoreEvent({
    required this.type,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'CoreEvent($type, $data)';
}

/// 核心事件总线
/// 用于 GUI 层订阅核心层发出的各种事件
class CoreEventBus {
  CoreEventBus._();
  static final instance = CoreEventBus._();

  final _controller = StreamController<CoreEvent>.broadcast();

  /// 事件流
  Stream<CoreEvent> get stream => _controller.stream;

  /// 按类型过滤事件
  Stream<CoreEvent> on(CoreEventType type) =>
      _controller.stream.where((e) => e.type == type);

  /// 发送事件
  void emit(CoreEventType type, [dynamic data]) {
    _controller.add(CoreEvent(type: type, data: data));
  }

  /// 发送核心启动事件
  void emitStarted({int? pid}) =>
      emit(CoreEventType.started, {'pid': pid});

  /// 发送核心停止事件
  void emitStopped({int? exitCode}) =>
      emit(CoreEventType.stopped, {'exitCode': exitCode});

  /// 发送核心崩溃事件
  void emitCrashed({String? error, int? exitCode}) =>
      emit(CoreEventType.crashed, {'error': error, 'exitCode': exitCode});

  /// 发送配置加载事件
  void emitConfigLoaded() => emit(CoreEventType.configLoaded);

  /// 发送配置错误事件
  void emitConfigError(String message) =>
      emit(CoreEventType.configError, message);

  /// 发送权限需求事件
  void emitPermissionRequired(String reason) =>
      emit(CoreEventType.permissionRequired, reason);

  /// 发送核心未找到事件
  void emitCoreNotFound() => emit(CoreEventType.coreNotFound);

  void dispose() {
    _controller.close();
  }
}
