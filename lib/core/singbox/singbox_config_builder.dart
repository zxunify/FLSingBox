import '../../models/node/node.dart';
import '../../models/node/protocols/protocol_configs.dart';
import '../../models/group/node_group.dart';
import '../../models/route/route_rule.dart';
import '../../models/protocol_type.dart';

/// sing-box 配置构建器
/// 将 GUI 数据模型转换为 sing-box JSON 配置
class SingBoxConfigBuilder {
  final List<Node> nodes;
  final List<NodeGroup> groups;
  final List<RouteRule> routeRules;
  final String proxyMode; // 'rule', 'global', 'direct'
  final String? selectedNodeId;
  final bool enableTun;
  final bool enableSystemProxy;
  final String logLevel;
  final String? clashApiPort;

  SingBoxConfigBuilder({
    required this.nodes,
    required this.groups,
    required this.routeRules,
    this.proxyMode = 'rule',
    this.selectedNodeId,
    this.enableTun = false,
    this.enableSystemProxy = true,
    this.logLevel = 'info',
    this.clashApiPort,
  });

  Map<String, dynamic> build() {
    final enabledNodes = nodes.where((n) => n.enabled).toList();

    return {
      'log': _buildLog(),
      'dns': _buildDns(),
      'inbounds': _buildInbounds(),
      'outbounds': _buildOutbounds(enabledNodes),
      'route': _buildRoute(),
      if (clashApiPort != null) 'experimental': _buildExperimental(),
    };
  }

  Map<String, dynamic> _buildLog() => {
        'level': logLevel,
        'timestamp': true,
      };

  Map<String, dynamic> _buildDns() => {
        'servers': [
          {
            'tag': 'dns-remote',
            'address': 'https://1.1.1.1/dns-query',
            'address_resolver': 'dns-local',
            'detour': 'proxy',
          },
          {
            'tag': 'dns-local',
            'address': '223.5.5.5',
            'detour': 'direct',
          },
          {
            'tag': 'dns-block',
            'address': 'rcode://success',
          },
        ],
        'rules': [
          {
            'outbound': 'any',
            'server': 'dns-local',
          },
          {
            'geosite': ['cn'],
            'server': 'dns-local',
          },
          {
            'geosite': ['geolocation-!cn'],
            'server': 'dns-remote',
          },
        ],
        'final': 'dns-remote',
        'independent_cache': true,
      };

  List<Map<String, dynamic>> _buildInbounds() {
    final inbounds = <Map<String, dynamic>>[];

    // SOCKS 入站
    inbounds.add({
      'type': 'socks',
      'tag': 'socks-in',
      'listen': '127.0.0.1',
      'listen_port': 7890,
      'sniff': true,
    });

    // HTTP 入站
    inbounds.add({
      'type': 'http',
      'tag': 'http-in',
      'listen': '127.0.0.1',
      'listen_port': 7891,
      'sniff': true,
    });

    // TUN 入站
    if (enableTun) {
      inbounds.add({
        'type': 'tun',
        'tag': 'tun-in',
        'inet4_address': '172.19.0.1/30',
        'inet6_address': 'fdfe:dcba:9876::1/126',
        'mtu': 9000,
        'auto_route': true,
        'strict_route': true,
        'sniff': true,
      });
    }

    return inbounds;
  }

  List<Map<String, dynamic>> _buildOutbounds(List<Node> enabledNodes) {
    final outbounds = <Map<String, dynamic>>[];

    // 根据模式决定 proxy 出站
    if (proxyMode == 'global' && selectedNodeId != null) {
      final node = enabledNodes.firstWhere(
        (n) => n.id == selectedNodeId,
        orElse: () => enabledNodes.first,
      );
      final nodeOutbound = _nodeToOutbound(node);
      if (nodeOutbound != null) {
        outbounds.add(nodeOutbound);
        // proxy 指向该节点
        outbounds.add({
          'type': 'selector',
          'tag': 'proxy',
          'outbounds': [node.id],
        });
      }
    } else {
      // 规则/直连模式: 构建所有节点出站 + selector 组
      for (final node in enabledNodes) {
        final outbound = _nodeToOutbound(node);
        if (outbound != null) outbounds.add(outbound);
      }

      // 构建策略组
      for (final group in groups) {
        outbounds.add(_groupToOutbound(group, enabledNodes));
      }

      // 如果没有分组, 创建默认 proxy selector
      if (groups.isEmpty && enabledNodes.isNotEmpty) {
        outbounds.add({
          'type': 'selector',
          'tag': 'proxy',
          'outbounds': enabledNodes.map((n) => n.id).toList(),
          'default': selectedNodeId ?? enabledNodes.first.id,
        });
      } else if (groups.isNotEmpty) {
        final defaultGroup = groups.firstWhere(
          (g) => g.isDefault,
          orElse: () => groups.first,
        );
        outbounds.add({
          'type': 'selector',
          'tag': 'proxy',
          'outbounds': groups.map((g) => g.id).toList(),
          'default': defaultGroup.id,
        });
      } else {
        outbounds.add({'type': 'direct', 'tag': 'proxy'});
      }
    }

    // 固定出站
    outbounds.addAll([
      {'type': 'direct', 'tag': 'direct'},
      {'type': 'block', 'tag': 'block'},
      {'type': 'dns', 'tag': 'dns-out'},
    ]);

    return outbounds;
  }

  Map<String, dynamic>? _nodeToOutbound(Node node) {
    final base = {
      'tag': node.id,
      'server': node.server,
      'server_port': node.port,
      if (node.hasDetour) 'detour': node.detourTargetId,
    };

    try {
      switch (node.protocolType) {
        case ProtocolType.shadowsocks:
          final cfg = ShadowsocksConfig.fromJson(node.rawConfig);
          return {
            ...base,
            'type': 'shadowsocks',
            'method': cfg.method,
            'password': cfg.password,
            if (cfg.plugin != null) 'plugin': cfg.plugin,
            if (cfg.pluginOpts != null) 'plugin_opts': cfg.pluginOpts,
            'udp_over_tcp': cfg.udpOverTcp,
          };

        case ProtocolType.vmess:
          final cfg = VmessConfig.fromJson(node.rawConfig);
          final outbound = {
            ...base,
            'type': 'vmess',
            'uuid': cfg.uuid,
            'security': cfg.security,
            'alter_id': cfg.alterId,
          };
          _applyTransport(outbound, cfg.transport, cfg.wsPath, cfg.wsHeaders, cfg.grpcServiceName);
          if (cfg.tls) _applyTls(outbound, cfg.sni, cfg.allowInsecure);
          return outbound;

        case ProtocolType.vless:
          final cfg = VlessConfig.fromJson(node.rawConfig);
          final outbound = {
            ...base,
            'type': 'vless',
            'uuid': cfg.uuid,
            if (cfg.flow != VlessFlow.none) 'flow': 'xtls-rprx-vision',
          };
          if (cfg.reality) {
            outbound['tls'] = {
              'enabled': true,
              'server_name': cfg.serverName ?? node.server,
              'reality': {
                'enabled': true,
                'public_key': cfg.publicKey ?? '',
                'short_id': cfg.shortId ?? '',
              },
              'utls': {'enabled': true, 'fingerprint': 'chrome'},
            };
          } else if (cfg.tls) {
            _applyTls(outbound, cfg.sni, cfg.allowInsecure);
          }
          _applyTransport(outbound, cfg.transport, cfg.wsPath, {}, null);
          return outbound;

        case ProtocolType.trojan:
          final cfg = TrojanConfig.fromJson(node.rawConfig);
          final outbound = {
            ...base,
            'type': 'trojan',
            'password': cfg.password,
          };
          if (cfg.tls) _applyTls(outbound, cfg.sni, cfg.allowInsecure, alpn: cfg.alpn);
          _applyTransport(outbound, cfg.transport, cfg.wsPath, {}, null);
          return outbound;

        case ProtocolType.hysteria2:
          final cfg = Hysteria2Config.fromJson(node.rawConfig);
          final outbound = {
            ...base,
            'type': 'hysteria2',
            'password': cfg.password,
            if (cfg.obfs != null)
              'obfs': {
                'type': cfg.obfs,
                'password': cfg.obfsPassword ?? '',
              },
          };
          _applyTls(outbound, cfg.sni, cfg.allowInsecure, alpn: cfg.alpn);
          return outbound;

        case ProtocolType.tuic:
          final cfg = TuicConfig.fromJson(node.rawConfig);
          final outbound = {
            ...base,
            'type': 'tuic',
            'uuid': cfg.uuid,
            'password': cfg.password,
            'congestion_control': cfg.congestionControl,
          };
          _applyTls(outbound, cfg.sni, cfg.allowInsecure, alpn: cfg.alpn);
          return outbound;

        case ProtocolType.wireguard:
          final cfg = WireGuardConfig.fromJson(node.rawConfig);
          return {
            ...base,
            'type': 'wireguard',
            'private_key': cfg.privateKey,
            'peer_public_key': cfg.peerPublicKey,
            if (cfg.preSharedKey != null) 'pre_shared_key': cfg.preSharedKey,
            'local_address': cfg.localAddresses,
            'reserved': cfg.reserved,
            'mtu': cfg.mtu,
          };

        case ProtocolType.socks:
          final cfg = SocksHttpConfig.fromJson(node.rawConfig);
          return {
            ...base,
            'type': 'socks',
            'version': '${cfg.version}',
            if (cfg.username != null) 'username': cfg.username,
            if (cfg.password != null) 'password': cfg.password,
          };

        case ProtocolType.http:
          final cfg = SocksHttpConfig.fromJson(node.rawConfig);
          return {
            ...base,
            'type': 'http',
            if (cfg.username != null) 'username': cfg.username,
            if (cfg.password != null) 'password': cfg.password,
          };

        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _applyTls(
    Map<String, dynamic> outbound,
    String? sni,
    bool allowInsecure, {
    List<String> alpn = const [],
  }) {
    outbound['tls'] = {
      'enabled': true,
      if (sni != null) 'server_name': sni,
      'insecure': allowInsecure,
      if (alpn.isNotEmpty) 'alpn': alpn,
    };
  }

  void _applyTransport(
    Map<String, dynamic> outbound,
    VmessTransport transport,
    String? wsPath,
    Map<String, String> wsHeaders,
    String? grpcServiceName,
  ) {
    switch (transport) {
      case VmessTransport.ws:
        outbound['transport'] = {
          'type': 'ws',
          'path': wsPath ?? '/',
          if (wsHeaders.isNotEmpty) 'headers': wsHeaders,
        };
        break;
      case VmessTransport.grpc:
        outbound['transport'] = {
          'type': 'grpc',
          if (grpcServiceName != null) 'service_name': grpcServiceName,
        };
        break;
      case VmessTransport.h2:
        outbound['transport'] = {'type': 'http'};
        break;
      default:
        break;
    }
  }

  Map<String, dynamic> _groupToOutbound(
    NodeGroup group,
    List<Node> enabledNodes,
  ) {
    final memberIds = group.nodeIds
        .where((id) => enabledNodes.any((n) => n.id == id))
        .toList();

    if (memberIds.isEmpty && enabledNodes.isNotEmpty) {
      memberIds.addAll(enabledNodes.map((n) => n.id));
    }

    switch (group.type) {
      case NodeGroupType.urltest:
        return {
          'type': 'urltest',
          'tag': group.id,
          'outbounds': memberIds,
          'url': group.testUrl ?? 'https://www.gstatic.com/generate_204',
          'interval': '${group.testIntervalSeconds}s',
          'tolerance': 50,
        };
      case NodeGroupType.selector:
      default:
        return {
          'type': 'selector',
          'tag': group.id,
          'outbounds': memberIds,
          if (group.selectedNodeId != null) 'default': group.selectedNodeId,
        };
    }
  }

  Map<String, dynamic> _buildRoute() {
    if (proxyMode == 'global') {
      return {
        'rules': [
          {'protocol': 'dns', 'outbound': 'dns-out'},
        ],
        'final': 'proxy',
      };
    }

    if (proxyMode == 'direct') {
      return {
        'rules': [
          {'protocol': 'dns', 'outbound': 'dns-out'},
        ],
        'final': 'direct',
      };
    }

    // 规则模式
    final rules = <Map<String, dynamic>>[
      {'protocol': 'dns', 'outbound': 'dns-out'},
    ];

    // 只取启用的规则
    final enabledRules =
        routeRules.where((r) => r.enabled).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (final rule in enabledRules) {
      final ruleMap = _routeRuleToSingBox(rule);
      if (ruleMap != null) rules.add(ruleMap);
    }

    return {
      'rules': rules,
      'final': 'proxy',
      'auto_detect_interface': true,
    };
  }

  Map<String, dynamic>? _routeRuleToSingBox(RouteRule rule) {
    final outbound = _resolveOutbound(rule);
    switch (rule.type) {
      case RouteRuleType.domain:
        return {'domain': [rule.value], 'outbound': outbound};
      case RouteRuleType.domainSuffix:
        return {'domain_suffix': [rule.value], 'outbound': outbound};
      case RouteRuleType.domainKeyword:
        return {'domain_keyword': [rule.value], 'outbound': outbound};
      case RouteRuleType.ipCidr:
        return {'ip_cidr': [rule.value], 'outbound': outbound};
      case RouteRuleType.geoip:
        return {'geoip': [rule.value], 'outbound': outbound};
      case RouteRuleType.geosite:
        return {'geosite': [rule.value], 'outbound': outbound};
      case RouteRuleType.processName:
        return {'process_name': [rule.value], 'outbound': outbound};
      case RouteRuleType.port:
        return {'port': [int.tryParse(rule.value) ?? 0], 'outbound': outbound};
      default:
        return null;
    }
  }

  String _resolveOutbound(RouteRule rule) {
    switch (rule.outboundType) {
      case RouteOutboundType.direct:
        return 'direct';
      case RouteOutboundType.block:
        return 'block';
      case RouteOutboundType.node:
      case RouteOutboundType.group:
        return rule.outboundTargetId ?? 'proxy';
    }
  }

  Map<String, dynamic>? _buildExperimental() {
    if (clashApiPort == null) return null;
    return {
      'clash_api': {
        'external_controller': '127.0.0.1:$clashApiPort',
        'external_ui': 'ui',
        'secret': '',
      },
      'cache_file': {
        'enabled': true,
        'path': 'cache.db',
        'store_selected': true,
      },
    };
  }
}
