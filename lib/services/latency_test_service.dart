import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/node/node.dart';
import '../providers/app_providers.dart';

/// 节点延迟测试服务
class LatencyTestService {
  /// 测试单个节点的 TCP 连接延迟
  Future<int?> testNode(Node node) async {
    try {
      final stopwatch = Stopwatch()..start();
      final socket = await Socket.connect(
        node.server,
        node.port,
        timeout: const Duration(seconds: 5),
      );
      stopwatch.stop();
      socket.destroy();
      return stopwatch.elapsedMilliseconds;
    } on SocketException {
      return null;
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// 批量测试节点延迟
  /// [concurrency] 并发数
  /// [onProgress] 进度回调 (completed, total)
  Future<Map<String, int?>> testNodes(
    List<Node> nodes, {
    int concurrency = 5,
    void Function(int completed, int total)? onProgress,
  }) async {
    final results = <String, int?>{};
    int completed = 0;
    final total = nodes.length;

    // 使用信号量控制并发
    final semaphore = _Semaphore(concurrency);

    final futures = nodes.map((node) async {
      await semaphore.acquire();
      try {
        final latency = await testNode(node);
        results[node.id] = latency;
        completed++;
        onProgress?.call(completed, total);
      } finally {
        semaphore.release();
      }
    });

    await Future.wait(futures);
    return results;
  }
}

/// 简单信号量实现
class _Semaphore {
  int _count;
  final _waiters = <Completer<void>>[];

  _Semaphore(this._count);

  Future<void> acquire() async {
    if (_count > 0) {
      _count--;
      return;
    }
    final completer = Completer<void>();
    _waiters.add(completer);
    await completer.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete();
    } else {
      _count++;
    }
  }
}

/// 测速状态
class LatencyTestState {
  final bool isTesting;
  final int completed;
  final int total;
  final String? currentNode;

  const LatencyTestState({
    this.isTesting = false,
    this.completed = 0,
    this.total = 0,
    this.currentNode,
  });

  LatencyTestState copyWith({
    bool? isTesting,
    int? completed,
    int? total,
    String? currentNode,
  }) =>
      LatencyTestState(
        isTesting: isTesting ?? this.isTesting,
        completed: completed ?? this.completed,
        total: total ?? this.total,
        currentNode: currentNode ?? this.currentNode,
      );
}

final latencyTestServiceProvider = Provider<LatencyTestService>((ref) => LatencyTestService());

final latencyTestStateProvider = StateNotifierProvider<LatencyTestNotifier, LatencyTestState>(
  (ref) => LatencyTestNotifier(ref),
);

class LatencyTestNotifier extends StateNotifier<LatencyTestState> {
  final Ref _ref;

  LatencyTestNotifier(this._ref) : super(const LatencyTestState());

  /// 批量测试
  Future<void> testAll(List<Node> nodes) async {
    if (state.isTesting) return;
    state = LatencyTestState(isTesting: true, total: nodes.length);

    final service = _ref.read(latencyTestServiceProvider);
    final results = await service.testNodes(
      nodes,
      concurrency: 10,
      onProgress: (completed, total) {
        state = state.copyWith(completed: completed, total: total);
      },
    );

    // 更新全局延迟状态
    final latencyNotifier = _ref.read(nodeLatencyProvider.notifier);
    latencyNotifier.setAll(results);

    state = const LatencyTestState(isTesting: false);
  }

  /// 测试单个节点
  Future<void> testSingle(Node node) async {
    final service = _ref.read(latencyTestServiceProvider);
    final latency = await service.testNode(node);
    _ref.read(nodeLatencyProvider.notifier).setLatency(node.id, latency);
  }
}
