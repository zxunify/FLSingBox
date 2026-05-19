class Subscription {
  final String id;
  final String name;
  final String url;
  final String parserType; // 'uri_list', 'base64', 'singbox', 'clash'
  final bool enabled;
  final bool autoUpdate;
  final Duration updateInterval;
  final DateTime? lastUpdateTime;
  final String dedupStrategy; // 'hash', 'name'
  final String conflictStrategy; // 'overwrite', 'keep'
  final String? userAgent;
  final int nodeCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.name,
    required this.url,
    this.parserType = 'auto',
    this.enabled = true,
    this.autoUpdate = true,
    this.updateInterval = const Duration(hours: 12),
    this.lastUpdateTime,
    this.dedupStrategy = 'hash',
    this.conflictStrategy = 'overwrite',
    this.userAgent,
    this.nodeCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Subscription copyWith({
    String? id,
    String? name,
    String? url,
    String? parserType,
    bool? enabled,
    bool? autoUpdate,
    Duration? updateInterval,
    DateTime? lastUpdateTime,
    String? dedupStrategy,
    String? conflictStrategy,
    String? userAgent,
    int? nodeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Subscription(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        parserType: parserType ?? this.parserType,
        enabled: enabled ?? this.enabled,
        autoUpdate: autoUpdate ?? this.autoUpdate,
        updateInterval: updateInterval ?? this.updateInterval,
        lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
        dedupStrategy: dedupStrategy ?? this.dedupStrategy,
        conflictStrategy: conflictStrategy ?? this.conflictStrategy,
        userAgent: userAgent ?? this.userAgent,
        nodeCount: nodeCount ?? this.nodeCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'parser_type': parserType,
        'enabled': enabled,
        'auto_update': autoUpdate,
        'update_interval_seconds': updateInterval.inSeconds,
        'last_update_time': lastUpdateTime?.toIso8601String(),
        'dedup_strategy': dedupStrategy,
        'conflict_strategy': conflictStrategy,
        'user_agent': userAgent,
        'node_count': nodeCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
        parserType: json['parser_type'] as String? ?? 'auto',
        enabled: json['enabled'] as bool? ?? true,
        autoUpdate: json['auto_update'] as bool? ?? true,
        updateInterval: Duration(
          seconds: json['update_interval_seconds'] as int? ?? 43200,
        ),
        lastUpdateTime: json['last_update_time'] != null
            ? DateTime.parse(json['last_update_time'] as String)
            : null,
        dedupStrategy: json['dedup_strategy'] as String? ?? 'hash',
        conflictStrategy: json['conflict_strategy'] as String? ?? 'overwrite',
        userAgent: json['user_agent'] as String?,
        nodeCount: json['node_count'] as int? ?? 0,
        createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
        ),
      );
}
