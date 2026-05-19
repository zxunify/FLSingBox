import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/node_repository.dart';
import '../models/group/node_group.dart';
import '../models/route/route_rule.dart';
import '../core/database/app_database.dart' as db;

// 代理模式
enum ProxyMode {
  rule('规则模式'),
  global('全局代理'),
  direct('直连模式');

  final String label;
  const ProxyMode(this.label);
}

// 全局代理模式 Provider
final proxyModeProvider = StateProvider<ProxyMode>((ref) => ProxyMode.rule);

// 选中节点 Provider
final selectedNodeIdProvider = StateProvider<String?>((ref) => null);

// 分组列表 Provider
final nodeGroupsProvider = StateNotifierProvider<NodeGroupsNotifier, List<NodeGroup>>(
  (ref) => NodeGroupsNotifier(),
);

class NodeGroupsNotifier extends StateNotifier<List<NodeGroup>> {
  NodeGroupsNotifier() : super([]);

  void addGroup(NodeGroup group) => state = [...state, group];
  void removeGroup(String id) =>
      state = state.where((g) => g.id != id).toList();
  void updateGroup(NodeGroup group) => state = [
        for (final g in state)
          if (g.id == group.id) group else g
      ];
}

// 路由规则 Provider
final routeRulesProvider = StateNotifierProvider<RouteRulesNotifier, List<RouteRule>>(
  (ref) => RouteRulesNotifier(ref.watch(db.appDatabaseProvider)),
);

class RouteRulesNotifier extends StateNotifier<List<RouteRule>> {
  final db.AppDatabase _db;
  RouteRulesNotifier(this._db) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final rows = await _db.getAllRouteRules();
    // Convert DB rows to RouteRule models
    state = rows.map((r) => RouteRule(
      id: r.id,
      type: RouteRuleType.fromString(r.type),
      value: r.value,
      outboundType: RouteOutboundType.fromString(r.outboundType),
      outboundTargetId: r.outboundTargetId,
      enabled: r.enabled,
      orderIndex: r.orderIndex,
      remark: r.remark,
    )).toList();
  }

  void addRule(RouteRule rule) => state = [...state, rule];
  void removeRule(String id) =>
      state = state.where((r) => r.id != id).toList();
  void updateRule(RouteRule rule) => state = [
        for (final r in state)
          if (r.id == rule.id) rule else r
      ];
}

// 运行配置构建 Provider
final runtimeConfigProvider = Provider<Map<String, dynamic>?>((ref) {
  ref.watch(nodeRepositoryProvider);
  ref.watch(nodeGroupsProvider);
  ref.watch(routeRulesProvider);
  ref.watch(proxyModeProvider);
  ref.watch(selectedNodeIdProvider);
  return null; // Placeholder - built on demand via CoreManager
});

// 连接测速相关
final nodeLatencyProvider =
    StateNotifierProvider<NodeLatencyNotifier, Map<String, int?>>(
  (ref) => NodeLatencyNotifier(),
);

class NodeLatencyNotifier extends StateNotifier<Map<String, int?>> {
  NodeLatencyNotifier() : super({});

  void setLatency(String nodeId, int? latencyMs) {
    state = {...state, nodeId: latencyMs};
  }

  void setAll(Map<String, int?> results) {
    state = {...state, ...results};
  }
}
