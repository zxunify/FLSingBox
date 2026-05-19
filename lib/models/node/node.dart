import 'dart:convert';
import '../protocol_type.dart';
import '../node_source_type.dart';

class Node {
  final String id;
  final String displayName;
  final ProtocolType protocolType;
  final String server;
  final int port;
  final bool enabled;
  final NodeSourceType sourceType;
  final String? sourceId;
  final List<String> tags;
  final List<String> groupIds;
  final int? latencyMs;
  final DateTime? lastCheckTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isPinned;
  final String? detourTargetId;
  final String? rawUri;
  final Map<String, dynamic> rawConfig;
  final String? remark;
  final Map<String, dynamic> metadata;

  const Node({
    required this.id,
    required this.displayName,
    required this.protocolType,
    required this.server,
    required this.port,
    this.enabled = true,
    this.sourceType = NodeSourceType.manual,
    this.sourceId,
    this.tags = const [],
    this.groupIds = const [],
    this.latencyMs,
    this.lastCheckTime,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isPinned = false,
    this.detourTargetId,
    this.rawUri,
    this.rawConfig = const {},
    this.remark,
    this.metadata = const {},
  });

  Node copyWith({
    String? id,
    String? displayName,
    ProtocolType? protocolType,
    String? server,
    int? port,
    bool? enabled,
    NodeSourceType? sourceType,
    String? sourceId,
    List<String>? tags,
    List<String>? groupIds,
    int? latencyMs,
    DateTime? lastCheckTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isPinned,
    String? detourTargetId,
    String? rawUri,
    Map<String, dynamic>? rawConfig,
    String? remark,
    Map<String, dynamic>? metadata,
  }) {
    return Node(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      protocolType: protocolType ?? this.protocolType,
      server: server ?? this.server,
      port: port ?? this.port,
      enabled: enabled ?? this.enabled,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      tags: tags ?? this.tags,
      groupIds: groupIds ?? this.groupIds,
      latencyMs: latencyMs ?? this.latencyMs,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      detourTargetId: detourTargetId ?? this.detourTargetId,
      rawUri: rawUri ?? this.rawUri,
      rawConfig: rawConfig ?? this.rawConfig,
      remark: remark ?? this.remark,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'display_name': displayName,
        'protocol_type': protocolType.value,
        'server': server,
        'port': port,
        'enabled': enabled,
        'source_type': sourceType.value,
        'source_id': sourceId,
        'tags': tags,
        'group_ids': groupIds,
        'latency_ms': latencyMs,
        'last_check_time': lastCheckTime?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_favorite': isFavorite,
        'is_pinned': isPinned,
        'detour_target_id': detourTargetId,
        'raw_uri': rawUri,
        'raw_config': rawConfig,
        'remark': remark,
        'metadata': metadata,
      };

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        id: json['id'] as String,
        displayName: json['display_name'] as String,
        protocolType: ProtocolType.fromString(
          json['protocol_type'] as String? ?? 'unknown',
        ),
        server: json['server'] as String? ?? '',
        port: json['port'] as int? ?? 0,
        enabled: json['enabled'] as bool? ?? true,
        sourceType: NodeSourceType.fromString(
          json['source_type'] as String? ?? 'manual',
        ),
        sourceId: json['source_id'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        groupIds: (json['group_ids'] as List<dynamic>?)?.cast<String>() ?? [],
        latencyMs: json['latency_ms'] as int?,
        lastCheckTime: json['last_check_time'] != null
            ? DateTime.parse(json['last_check_time'] as String)
            : null,
        createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
        isFavorite: json['is_favorite'] as bool? ?? false,
        isPinned: json['is_pinned'] as bool? ?? false,
        detourTargetId: json['detour_target_id'] as String?,
        rawUri: json['raw_uri'] as String?,
        rawConfig: json['raw_config'] as Map<String, dynamic>? ?? {},
        remark: json['remark'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      );

  String get latencyDisplay {
    if (latencyMs == null) return '--';
    if (latencyMs! < 0) return '超时';
    return '${latencyMs}ms';
  }

  bool get hasDetour => detourTargetId != null && detourTargetId!.isNotEmpty;

  @override
  String toString() => 'Node($id, $displayName, ${protocolType.displayName})';
}
