import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DNS 服务器模型
class DnsServer {
  final String tag;
  final String address;
  final String type;
  final String? detour;
  final bool enabled;

  DnsServer({
    required this.tag,
    required this.address,
    this.type = 'udp',
    this.detour,
    this.enabled = true,
  });

  DnsServer copyWith({
    String? tag,
    String? address,
    String? type,
    String? detour,
    bool? enabled,
  }) =>
      DnsServer(
        tag: tag ?? this.tag,
        address: address ?? this.address,
        type: type ?? this.type,
        detour: detour ?? this.detour,
        enabled: enabled ?? this.enabled,
      );
}

/// DNS 规则模型
class DnsRule {
  final String id;
  final String type;
  final String value;
  final String serverTag;
  final bool enabled;

  DnsRule({
    required this.id,
    required this.type,
    required this.value,
    required this.serverTag,
    this.enabled = true,
  });
}

/// DNS 配置状态
class DnsConfig {
  final List<DnsServer> servers;
  final List<DnsRule> rules;
  final String defaultServer;
  final bool fakeip;
  final String fakeipRange;
  final bool disableCache;
  final bool independentCache;
  final String strategy;

  DnsConfig({
    this.servers = const [],
    this.rules = const [],
    this.defaultServer = 'remote',
    this.fakeip = false,
    this.fakeipRange = '198.18.0.0/15',
    this.disableCache = false,
    this.independentCache = false,
    this.strategy = 'prefer_ipv4',
  });

  DnsConfig copyWith({
    List<DnsServer>? servers,
    List<DnsRule>? rules,
    String? defaultServer,
    bool? fakeip,
    String? fakeipRange,
    bool? disableCache,
    bool? independentCache,
    String? strategy,
  }) =>
      DnsConfig(
        servers: servers ?? this.servers,
        rules: rules ?? this.rules,
        defaultServer: defaultServer ?? this.defaultServer,
        fakeip: fakeip ?? this.fakeip,
        fakeipRange: fakeipRange ?? this.fakeipRange,
        disableCache: disableCache ?? this.disableCache,
        independentCache: independentCache ?? this.independentCache,
        strategy: strategy ?? this.strategy,
      );

  Map<String, dynamic> toSingboxConfig() {
    final serverList = <Map<String, dynamic>>[];
    for (final s in servers.where((s) => s.enabled)) {
      final server = <String, dynamic>{'tag': s.tag, 'address': s.address};
      if (s.detour != null) server['detour'] = s.detour;
      serverList.add(server);
    }
    if (fakeip) {
      serverList.add({'tag': 'dns-fakeip', 'address': 'fakeip'});
    }

    final ruleList = <Map<String, dynamic>>[];
    for (final r in rules.where((r) => r.enabled)) {
      final rule = <String, dynamic>{'server': r.serverTag};
      switch (r.type) {
        case 'domain':
          rule['domain'] = [r.value];
        case 'domain_suffix':
          rule['domain_suffix'] = [r.value];
        case 'domain_keyword':
          rule['domain_keyword'] = [r.value];
        case 'geosite':
          rule['geosite'] = [r.value];
        default:
          rule['domain'] = [r.value];
      }
      ruleList.add(rule);
    }
    if (fakeip) {
      ruleList.add({'server': 'dns-fakeip', 'query_type': ['A', 'AAAA']});
    }

    final config = <String, dynamic>{
      'servers': serverList,
      'final': defaultServer,
      'strategy': strategy,
      'disable_cache': disableCache,
      'independent_cache': independentCache,
    };
    if (ruleList.isNotEmpty) config['rules'] = ruleList;
    if (fakeip) {
      config['fakeip'] = {
        'enabled': true,
        'inet4_range': fakeipRange,
        'inet6_range': 'fc00::/18',
      };
    }
    return config;
  }
}

final dnsConfigProvider = StateNotifierProvider<DnsConfigNotifier, DnsConfig>(
  (ref) => DnsConfigNotifier(),
);

class DnsConfigNotifier extends StateNotifier<DnsConfig> {
  DnsConfigNotifier()
      : super(DnsConfig(
          servers: [
            DnsServer(tag: 'remote', address: 'https://1.1.1.1/dns-query', type: 'doh', detour: 'proxy'),
            DnsServer(tag: 'local', address: '223.5.5.5', type: 'udp'),
            DnsServer(tag: 'block', address: 'rcode://success', type: 'udp'),
          ],
          rules: [
            DnsRule(id: '1', type: 'geosite', value: 'cn', serverTag: 'local'),
            DnsRule(id: '2', type: 'geosite', value: 'category-ads-all', serverTag: 'block'),
          ],
        ));

  void addServer(DnsServer server) => state = state.copyWith(servers: [...state.servers, server]);
  void removeServer(int index) {
    final s = [...state.servers]..removeAt(index);
    state = state.copyWith(servers: s);
  }
  void updateServer(int index, DnsServer server) {
    final s = [...state.servers]; s[index] = server;
    state = state.copyWith(servers: s);
  }
  void addRule(DnsRule rule) => state = state.copyWith(rules: [...state.rules, rule]);
  void removeRule(int index) {
    final r = [...state.rules]..removeAt(index);
    state = state.copyWith(rules: r);
  }
  void updateRule(int index, DnsRule rule) {
    final r = [...state.rules]; r[index] = rule;
    state = state.copyWith(rules: r);
  }
  void setDefaultServer(String tag) => state = state.copyWith(defaultServer: tag);
  void setFakeip(bool v) => state = state.copyWith(fakeip: v);
  void setFakeipRange(String v) => state = state.copyWith(fakeipRange: v);
  void setDisableCache(bool v) => state = state.copyWith(disableCache: v);
  void setIndependentCache(bool v) => state = state.copyWith(independentCache: v);
  void setStrategy(String v) => state = state.copyWith(strategy: v);
}

class DnsSettingsPage extends ConsumerWidget {
  const DnsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(dnsConfigProvider);
    final notifier = ref.read(dnsConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('DNS 设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader(context, 'DNS 服务器', onAdd: () => _addServerDialog(context, notifier)),
          ...config.servers.asMap().entries.map((e) => _serverTile(context, e.key, e.value, config, notifier)),
          const SizedBox(height: 16),
          _sectionHeader(context, 'DNS 规则', onAdd: () => _addRuleDialog(context, notifier, config.servers)),
          ...config.rules.asMap().entries.map((e) => _ruleTile(context, e.key, e.value, notifier)),
          const SizedBox(height: 16),
          _sectionHeader(context, '高级设置'),
          Card(
            child: Column(children: [
              SwitchListTile(title: const Text('FakeIP'), subtitle: const Text('使用虚假 IP 加速解析'), value: config.fakeip, onChanged: notifier.setFakeip),
              if (config.fakeip) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(initialValue: config.fakeipRange, decoration: const InputDecoration(labelText: 'FakeIP 范围'), onChanged: notifier.setFakeipRange),
              ),
              const Divider(height: 1),
              SwitchListTile(title: const Text('禁用缓存'), value: config.disableCache, onChanged: notifier.setDisableCache),
              const Divider(height: 1),
              SwitchListTile(title: const Text('独立缓存'), value: config.independentCache, onChanged: notifier.setIndependentCache),
              const Divider(height: 1),
              ListTile(
                title: const Text('DNS 策略'),
                trailing: DropdownButton<String>(
                  value: config.strategy, underline: const SizedBox(),
                  onChanged: (v) { if (v != null) notifier.setStrategy(v); },
                  items: const [
                    DropdownMenuItem(value: 'prefer_ipv4', child: Text('优先 IPv4')),
                    DropdownMenuItem(value: 'prefer_ipv6', child: Text('优先 IPv6')),
                    DropdownMenuItem(value: 'ipv4_only', child: Text('仅 IPv4')),
                    DropdownMenuItem(value: 'ipv6_only', child: Text('仅 IPv6')),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, {VoidCallback? onAdd}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (onAdd != null) IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
      ]),
    );
  }

  Widget _serverTile(BuildContext context, int i, DnsServer server, DnsConfig config, DnsConfigNotifier notifier) {
    return Card(
      child: ListTile(
        leading: Icon(server.type == 'doh' ? Icons.https : server.type == 'dot' ? Icons.security : Icons.dns,
            color: server.enabled ? Theme.of(context).colorScheme.primary : Colors.grey),
        title: Text(server.tag),
        subtitle: Text(server.address, overflow: TextOverflow.ellipsis),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (config.defaultServer == server.tag)
            const Padding(padding: EdgeInsets.only(right: 4), child: Chip(label: Text('默认', style: TextStyle(fontSize: 10)), padding: EdgeInsets.zero, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)),
          Switch(value: server.enabled, onChanged: (v) => notifier.updateServer(i, server.copyWith(enabled: v))),
          PopupMenuButton<String>(
            onSelected: (a) {
              if (a == 'default') notifier.setDefaultServer(server.tag);
              else if (a == 'delete') notifier.removeServer(i);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'default', child: Text('设为默认')),
              const PopupMenuItem(value: 'delete', child: Text('删除')),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _ruleTile(BuildContext context, int i, DnsRule rule, DnsConfigNotifier notifier) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.rule),
        title: Text('${rule.type}: ${rule.value}'),
        subtitle: Text('→ ${rule.serverTag}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Switch(value: rule.enabled, onChanged: (v) => notifier.updateRule(i, DnsRule(id: rule.id, type: rule.type, value: rule.value, serverTag: rule.serverTag, enabled: v))),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => notifier.removeRule(i)),
        ]),
      ),
    );
  }

  void _addServerDialog(BuildContext context, DnsConfigNotifier notifier) {
    final tagC = TextEditingController();
    final addrC = TextEditingController();
    String type = 'udp';
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => AlertDialog(
      title: const Text('添加 DNS 服务器'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: tagC, decoration: const InputDecoration(labelText: '标签')),
        const SizedBox(height: 8),
        TextField(controller: addrC, decoration: const InputDecoration(labelText: '地址', hintText: 'https://dns.google/dns-query')),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: '类型'), items: const [
          DropdownMenuItem(value: 'udp', child: Text('UDP')), DropdownMenuItem(value: 'tcp', child: Text('TCP')),
          DropdownMenuItem(value: 'doh', child: Text('DoH')), DropdownMenuItem(value: 'dot', child: Text('DoT')),
        ], onChanged: (v) => ss(() => type = v ?? 'udp')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        FilledButton(onPressed: () { if (tagC.text.isNotEmpty && addrC.text.isNotEmpty) { notifier.addServer(DnsServer(tag: tagC.text, address: addrC.text, type: type)); Navigator.pop(ctx); } }, child: const Text('添加')),
      ],
    )));
  }

  void _addRuleDialog(BuildContext context, DnsConfigNotifier notifier, List<DnsServer> servers) {
    final valueC = TextEditingController();
    String type = 'domain_suffix';
    String serverTag = servers.isNotEmpty ? servers.first.tag : '';
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => AlertDialog(
      title: const Text('添加 DNS 规则'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: '匹配类型'), items: const [
          DropdownMenuItem(value: 'domain', child: Text('域名')), DropdownMenuItem(value: 'domain_suffix', child: Text('域名后缀')),
          DropdownMenuItem(value: 'domain_keyword', child: Text('关键字')), DropdownMenuItem(value: 'geosite', child: Text('GeoSite')),
        ], onChanged: (v) => ss(() => type = v ?? 'domain_suffix')),
        const SizedBox(height: 8),
        TextField(controller: valueC, decoration: const InputDecoration(labelText: '值', hintText: 'cn, google.com')),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(value: serverTag, decoration: const InputDecoration(labelText: 'DNS 服务器'),
          items: servers.map((s) => DropdownMenuItem(value: s.tag, child: Text(s.tag))).toList(),
          onChanged: (v) => ss(() => serverTag = v ?? '')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        FilledButton(onPressed: () { if (valueC.text.isNotEmpty) { notifier.addRule(DnsRule(id: DateTime.now().millisecondsSinceEpoch.toString(), type: type, value: valueC.text, serverTag: serverTag)); Navigator.pop(ctx); } }, child: const Text('添加')),
      ],
    )));
  }
}
