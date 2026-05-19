/// @deprecated 使用 [CoreManager] 代替
/// 此文件保留向后兼容，新代码应使用 lib/core/manager/core_manager.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../manager/core_manager.dart';
import '../manager/core_status.dart';

// sing-box 运行状态 (向后兼容)
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

  /// 从 CoreStatus 转换
  factory SingBoxState.fromCoreStatus(CoreStatus coreStatus) {
    final status = switch (coreStatus.phase) {
      CorePhase.stopped => SingBoxStatus.stopped,
      CorePhase.starting => SingBoxStatus.starting,
      CorePhase.running => SingBoxStatus.running,
      CorePhase.stopping => SingBoxStatus.stopping,
      CorePhase.error => SingBoxStatus.error,
      CorePhase.crashed => SingBoxStatus.error,
    };
    return SingBoxState(
      status: status,
      errorMessage: coreStatus.errorMessage,
      startTime: coreStatus.startTime,
      pid: coreStatus.pid,
    );
  }
}

/// @deprecated 使用 [coreManagerProvider] 代替
final singBoxControllerProvider =
    StateNotifierProvider<_SingBoxControllerAdapter, SingBoxState>(
  (ref) {
    final coreStatus = ref.watch(coreManagerProvider);
    return _SingBoxControllerAdapter(ref, coreStatus);
  },
);

class _SingBoxControllerAdapter extends StateNotifier<SingBoxState> {
  final Ref _ref;

  _SingBoxControllerAdapter(this._ref, CoreStatus coreStatus)
      : super(SingBoxState.fromCoreStatus(coreStatus));

  Stream<String> get logStream =>
      _ref.read(coreManagerProvider.notifier).rawLogStream;

  Future<void> start(Map<String, dynamic> config) async {
    final manager = _ref.read(coreManagerProvider.notifier);
    final configPath = await manager.configManager.writeConfig(config);
    await manager.startWithConfig(configPath);
    state = SingBoxState.fromCoreStatus(_ref.read(coreManagerProvider));
  }

  Future<void> stop() async {
    await _ref.read(coreManagerProvider.notifier).stop();
    state = SingBoxState.fromCoreStatus(_ref.read(coreManagerProvider));
  }

  Future<void> restart(Map<String, dynamic> config) async {
    await stop();
    await Future.delayed(const Duration(milliseconds: 300));
    await start(config);
  }

  Future<({bool valid, String message})> checkConfig(
    Map<String, dynamic> config,
  ) async {
    final manager = _ref.read(coreManagerProvider.notifier);
    final configPath = await manager.configManager.writeConfig(config);
    final result = await manager.configManager.validator.validate(configPath);
    return (valid: result.valid, message: result.summary);
  }
}
