// 核心运行状态定义

/// 核心运行阶段
enum CorePhase {
  stopped('已停止'),
  starting('启动中'),
  running('运行中'),
  stopping('停止中'),
  error('错误'),
  crashed('已崩溃');

  final String label;
  const CorePhase(this.label);
}

/// 核心状态
class CoreStatus {
  final CorePhase phase;
  final String? errorMessage;
  final DateTime? startTime;
  final DateTime? lastCrashTime;
  final int? pid;
  final String? coreVersion;

  const CoreStatus({
    this.phase = CorePhase.stopped,
    this.errorMessage,
    this.startTime,
    this.lastCrashTime,
    this.pid,
    this.coreVersion,
  });

  bool get isRunning => phase == CorePhase.running;
  bool get isStopped => phase == CorePhase.stopped;
  bool get hasError => phase == CorePhase.error;
  bool get isCrashed => phase == CorePhase.crashed;
  bool get isStarting => phase == CorePhase.starting;
  bool get isStopping => phase == CorePhase.stopping;

  /// 运行时长
  Duration? get uptime {
    if (startTime == null || !isRunning) return null;
    return DateTime.now().difference(startTime!);
  }

  CoreStatus copyWith({
    CorePhase? phase,
    String? errorMessage,
    DateTime? startTime,
    DateTime? lastCrashTime,
    int? pid,
    String? coreVersion,
  }) =>
      CoreStatus(
        phase: phase ?? this.phase,
        errorMessage: errorMessage ?? this.errorMessage,
        startTime: startTime ?? this.startTime,
        lastCrashTime: lastCrashTime ?? this.lastCrashTime,
        pid: pid ?? this.pid,
        coreVersion: coreVersion ?? this.coreVersion,
      );

  @override
  String toString() =>
      'CoreStatus(phase=$phase, pid=$pid, version=$coreVersion)';
}
