// 节点分组类型
enum NodeGroupType {
  selector('selector', '手动选择组'),
  urltest('urltest', '自动测速组'),
  manual('manual', '普通分组'),
  chain('chain', '链式代理组');

  final String value;
  final String displayName;
  const NodeGroupType(this.value, this.displayName);

  static NodeGroupType fromString(String v) => NodeGroupType.values
      .firstWhere((e) => e.value == v, orElse: () => NodeGroupType.manual);
}

class NodeGroup {
  final String id;
  final String name;
  final NodeGroupType type;
  final List<String> nodeIds;
  final String? selectedNodeId;
  final String? testUrl;
  final int testIntervalSeconds;
  final String? remark;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NodeGroup({
    required this.id,
    required this.name,
    this.type = NodeGroupType.manual,
    this.nodeIds = const [],
    this.selectedNodeId,
    this.testUrl = 'https://www.gstatic.com/generate_204',
    this.testIntervalSeconds = 300,
    this.remark,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  NodeGroup copyWith({
    String? id,
    String? name,
    NodeGroupType? type,
    List<String>? nodeIds,
    String? selectedNodeId,
    String? testUrl,
    int? testIntervalSeconds,
    String? remark,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      NodeGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        nodeIds: nodeIds ?? this.nodeIds,
        selectedNodeId: selectedNodeId ?? this.selectedNodeId,
        testUrl: testUrl ?? this.testUrl,
        testIntervalSeconds: testIntervalSeconds ?? this.testIntervalSeconds,
        remark: remark ?? this.remark,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.value,
        'node_ids': nodeIds,
        'selected_node_id': selectedNodeId,
        'test_url': testUrl,
        'test_interval_seconds': testIntervalSeconds,
        'remark': remark,
        'is_default': isDefault,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory NodeGroup.fromJson(Map<String, dynamic> json) => NodeGroup(
        id: json['id'] as String,
        name: json['name'] as String,
        type: NodeGroupType.fromString(json['type'] as String? ?? 'manual'),
        nodeIds: (json['node_ids'] as List<dynamic>?)?.cast<String>() ?? [],
        selectedNodeId: json['selected_node_id'] as String?,
        testUrl: json['test_url'] as String?,
        testIntervalSeconds: json['test_interval_seconds'] as int? ?? 300,
        remark: json['remark'] as String?,
        isDefault: json['is_default'] as bool? ?? false,
        createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
      );
}
