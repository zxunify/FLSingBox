import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/database/app_database.dart' as db;
import '../models/subscription/subscription.dart';
import '../models/node/node.dart';
import 'node_repository.dart';
import '../services/subscription_sync_service.dart';

const _uuid = Uuid();

class SubscriptionRepository {
  final db.AppDatabase _db;
  final NodeRepository _nodeRepo;
  final SubscriptionSyncService _syncService;

  SubscriptionRepository(this._db, this._nodeRepo, this._syncService);

  Stream<List<Subscription>> watchAll() =>
      _db.watchAllSubscriptions().map((rows) => rows.map(_fromRow).toList());

  Future<List<Subscription>> getAll() async {
    final rows = await _db.getAllSubscriptions();
    return rows.map(_fromRow).toList();
  }

  Future<void> save(Subscription sub) async {
    final companion = _toCompanion(sub);
    final existing = await _db
        .select(_db.subscriptions)
        .get()
        .then((l) => l.any((r) => r.id == sub.id));

    if (!existing) {
      await _db.insertSubscription(companion);
    } else {
      await _db.updateSubscription(companion);
    }
  }

  Future<void> delete(String id) async {
    await _nodeRepo.deleteBySubscription(id);
    await _db.deleteSubscription(id);
  }

  /// 同步订阅
  Future<({int added, int removed, String? error})> sync(
    Subscription subscription,
  ) async {
    final result = await _syncService.fetchAndParse(subscription);

    if (result.result.error != null) {
      return (added: 0, removed: 0, error: result.result.error);
    }

    final newNodes = result.nodes;

    // 策略: 严格同步 or 保留历史
    if (subscription.conflictStrategy == 'overwrite') {
      // 删除旧节点
      final oldNodes = await _nodeRepo.getBySubscription(subscription.id);
      await _nodeRepo.deleteBySubscription(subscription.id);
      // 保存新节点
      await _nodeRepo.saveAll(newNodes);

      // 更新订阅统计
      await save(
        subscription.copyWith(
          lastUpdateTime: DateTime.now(),
          nodeCount: newNodes.length,
          updatedAt: DateTime.now(),
        ),
      );

      return (
        added: newNodes.length,
        removed: oldNodes.length,
        error: null,
      );
    } else {
      // 保留历史: 差异合并
      final oldNodes = await _nodeRepo.getBySubscription(subscription.id);
      final oldUris = <String, Node>{};
      for (final n in oldNodes) {
        if (n.rawUri != null) oldUris[n.rawUri!] = n;
      }

      int added = 0;
      for (final node in newNodes) {
        if (node.rawUri == null || !oldUris.containsKey(node.rawUri)) {
          await _nodeRepo.save(node);
          added++;
        }
      }

      await save(
        subscription.copyWith(
          lastUpdateTime: DateTime.now(),
          nodeCount: oldNodes.length + added,
          updatedAt: DateTime.now(),
        ),
      );

      return (added: added, removed: 0, error: null);
    }
  }

  Subscription _fromRow(dynamic row) => Subscription(
        id: row.id,
        name: row.name,
        url: row.url,
        parserType: row.parserType,
        enabled: row.enabled,
        autoUpdate: row.autoUpdate,
        updateInterval: Duration(seconds: row.updateIntervalSeconds),
        lastUpdateTime: row.lastUpdateTime,
        dedupStrategy: row.dedupStrategy,
        conflictStrategy: row.conflictStrategy,
        userAgent: row.userAgent,
        nodeCount: row.nodeCount,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  db.SubscriptionsCompanion _toCompanion(Subscription sub) =>
      db.SubscriptionsCompanion.insert(
        id: sub.id,
        name: sub.name,
        url: sub.url,
        parserType: Value(sub.parserType),
        enabled: Value(sub.enabled),
        autoUpdate: Value(sub.autoUpdate),
        updateIntervalSeconds: Value(sub.updateInterval.inSeconds),
        lastUpdateTime: Value(sub.lastUpdateTime),
        dedupStrategy: Value(sub.dedupStrategy),
        conflictStrategy: Value(sub.conflictStrategy),
        userAgent: Value(sub.userAgent),
        nodeCount: Value(sub.nodeCount),
        createdAt: sub.createdAt,
        updatedAt: sub.updatedAt,
      );
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(
    ref.watch(db.appDatabaseProvider),
    ref.watch(nodeRepositoryProvider),
    ref.watch(subscriptionSyncServiceProvider),
  ),
);
