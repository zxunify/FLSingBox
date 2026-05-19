import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Nodes,
    Subscriptions,
    NodeGroups,
    RouteRules,
    ImportTasks,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _insertDefaultData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations here
        },
      );

  Future<void> _insertDefaultData() async {
    // 插入默认路由规则
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(routeRules, [
        RouteRulesCompanion.insert(
          id: 'default-cn-direct',
          type: 'geosite',
          value: 'cn',
          outboundType: const Value('direct'),
          enabled: const Value(true),
          orderIndex: const Value(10),
          remark: const Value('中国域名直连'),
          createdAt: now,
          updatedAt: now,
        ),
        RouteRulesCompanion.insert(
          id: 'default-private-direct',
          type: 'geoip',
          value: 'private',
          outboundType: const Value('direct'),
          enabled: const Value(true),
          orderIndex: const Value(5),
          remark: const Value('内网地址直连'),
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
  }

  // ========== Nodes DAOs ==========
  Future<List<Node>> getAllNodes() => select(nodes).get();

  Stream<List<Node>> watchAllNodes() => select(nodes).watch();

  Future<Node?> getNodeById(String id) =>
      (select(nodes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertNode(NodesCompanion node) => into(nodes).insert(node);

  Future<void> updateNode(NodesCompanion node) =>
      (update(nodes)..where((t) => t.id.equals(node.id.value))).write(node);

  Future<void> deleteNode(String id) =>
      (delete(nodes)..where((t) => t.id.equals(id))).go();

  Future<List<Node>> getNodesBySubscription(String subscriptionId) =>
      (select(nodes)..where((t) => t.sourceId.equals(subscriptionId))).get();

  // ========== Subscriptions DAOs ==========
  Future<List<Subscription>> getAllSubscriptions() =>
      select(subscriptions).get();

  Stream<List<Subscription>> watchAllSubscriptions() =>
      select(subscriptions).watch();

  Future<void> insertSubscription(SubscriptionsCompanion sub) =>
      into(subscriptions).insert(sub);

  Future<void> updateSubscription(SubscriptionsCompanion sub) =>
      (update(subscriptions)..where((t) => t.id.equals(sub.id.value)))
          .write(sub);

  Future<void> deleteSubscription(String id) =>
      (delete(subscriptions)..where((t) => t.id.equals(id))).go();

  // ========== Groups DAOs ==========
  Future<List<NodeGroup>> getAllGroups() => select(nodeGroups).get();

  Stream<List<NodeGroup>> watchAllGroups() => select(nodeGroups).watch();

  Future<void> insertGroup(NodeGroupsCompanion group) =>
      into(nodeGroups).insert(group);

  Future<void> updateGroup(NodeGroupsCompanion group) =>
      (update(nodeGroups)..where((t) => t.id.equals(group.id.value)))
          .write(group);

  Future<void> deleteGroup(String id) =>
      (delete(nodeGroups)..where((t) => t.id.equals(id))).go();

  // ========== Route Rules DAOs ==========
  Future<List<RouteRule>> getAllRouteRules() =>
      (select(routeRules)..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])).get();

  Stream<List<RouteRule>> watchAllRouteRules() =>
      (select(routeRules)..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])).watch();

  Future<void> insertRouteRule(RouteRulesCompanion rule) =>
      into(routeRules).insert(rule);

  Future<void> updateRouteRule(RouteRulesCompanion rule) =>
      (update(routeRules)..where((t) => t.id.equals(rule.id.value))).write(rule);

  Future<void> deleteRouteRule(String id) =>
      (delete(routeRules)..where((t) => t.id.equals(id))).go();

  // ========== Settings DAOs ==========
  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          key: Value(key),
          value: Value(value),
        ),
      );
}

// Riverpod provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('AppDatabase must be initialized in main()');
});
