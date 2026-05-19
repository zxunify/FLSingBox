// 路由规则类型
enum RouteRuleType {
  domain('domain', '域名'),
  domainSuffix('domain_suffix', '域名后缀'),
  domainKeyword('domain_keyword', '域名关键词'),
  ipCidr('ip_cidr', 'IP/CIDR'),
  geoip('geoip', 'GeoIP'),
  geosite('geosite', 'GeoSite'),
  processName('process_name', '进程名'),
  port('port', '端口'),
  network('network', '网络类型'),
  ruleSet('rule_set', '规则集');

  final String value;
  final String displayName;
  const RouteRuleType(this.value, this.displayName);

  static RouteRuleType fromString(String v) => RouteRuleType.values
      .firstWhere((e) => e.value == v, orElse: () => RouteRuleType.domain);
}

// 路由目标类型
enum RouteOutboundType {
  node('node', '节点'),
  group('group', '分组'),
  direct('direct', '直连'),
  block('block', '阻断');

  final String value;
  final String displayName;
  const RouteOutboundType(this.value, this.displayName);

  static RouteOutboundType fromString(String v) =>
      RouteOutboundType.values.firstWhere(
        (e) => e.value == v,
        orElse: () => RouteOutboundType.direct,
      );
}

class RouteRule {
  final String id;
  final RouteRuleType type;
  final String value;
  final RouteOutboundType outboundType;
  final String? outboundTargetId;
  final bool enabled;
  final int orderIndex;
  final String? remark;

  const RouteRule({
    required this.id,
    required this.type,
    required this.value,
    this.outboundType = RouteOutboundType.direct,
    this.outboundTargetId,
    this.enabled = true,
    this.orderIndex = 0,
    this.remark,
  });

  RouteRule copyWith({
    String? id,
    RouteRuleType? type,
    String? value,
    RouteOutboundType? outboundType,
    String? outboundTargetId,
    bool? enabled,
    int? orderIndex,
    String? remark,
  }) =>
      RouteRule(
        id: id ?? this.id,
        type: type ?? this.type,
        value: value ?? this.value,
        outboundType: outboundType ?? this.outboundType,
        outboundTargetId: outboundTargetId ?? this.outboundTargetId,
        enabled: enabled ?? this.enabled,
        orderIndex: orderIndex ?? this.orderIndex,
        remark: remark ?? this.remark,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'value': value,
        'outbound_type': outboundType.value,
        'outbound_target_id': outboundTargetId,
        'enabled': enabled,
        'order_index': orderIndex,
        'remark': remark,
      };

  factory RouteRule.fromJson(Map<String, dynamic> json) => RouteRule(
        id: json['id'] as String,
        type: RouteRuleType.fromString(json['type'] as String? ?? 'domain'),
        value: json['value'] as String? ?? '',
        outboundType: RouteOutboundType.fromString(
          json['outbound_type'] as String? ?? 'direct',
        ),
        outboundTargetId: json['outbound_target_id'] as String?,
        enabled: json['enabled'] as bool? ?? true,
        orderIndex: json['order_index'] as int? ?? 0,
        remark: json['remark'] as String?,
      );
}
