import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../models/node/node.dart';
import '../../models/node/protocols/protocol_configs.dart';
import '../../models/protocol_type.dart';
import '../../models/node_source_type.dart';
import '../../repositories/node_repository.dart';

const _uuid = Uuid();

class NodeEditPage extends ConsumerStatefulWidget {
  final String? nodeId;
  const NodeEditPage({super.key, this.nodeId});

  @override
  ConsumerState<NodeEditPage> createState() => _NodeEditPageState();
}

class _NodeEditPageState extends ConsumerState<NodeEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isNew = true;
  Node? _node;

  // 基础字段
  ProtocolType _protocolType = ProtocolType.shadowsocks;
  final _nameCtrl = TextEditingController();
  final _serverCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  // 通用协议字段
  final _passwordCtrl = TextEditingController();
  final _uuidCtrl = TextEditingController();
  final _methodCtrl = TextEditingController(text: 'aes-256-gcm');
  final _sniCtrl = TextEditingController();
  final _wsPathCtrl = TextEditingController();
  final _grpcServiceNameCtrl = TextEditingController();
  final _privateKeyCtrl = TextEditingController();
  final _publicKeyCtrl = TextEditingController();
  final _shortIdCtrl = TextEditingController();

  bool _tls = false;
  bool _reality = false;
  bool _allowInsecure = false;
  VmessTransport _transport = VmessTransport.tcp;
  VlessFlow _vlessFlow = VlessFlow.none;
  String _securityVmess = 'auto';
  String _congestionControl = 'bbr';

  @override
  void initState() {
    super.initState();
    _loadNode();
  }

  Future<void> _loadNode() async {
    if (widget.nodeId != null) {
      final node =
          await ref.read(nodeRepositoryProvider).getById(widget.nodeId!);
      if (node != null) {
        _isNew = false;
        _node = node;
        _protocolType = node.protocolType;
        _nameCtrl.text = node.displayName;
        _serverCtrl.text = node.server;
        _portCtrl.text = node.port.toString();
        _remarkCtrl.text = node.remark ?? '';
        _loadProtocolFields(node);
      }
    }
    setState(() => _isLoading = false);
  }

  void _loadProtocolFields(Node node) {
    final cfg = node.rawConfig;
    switch (node.protocolType) {
      case ProtocolType.shadowsocks:
        final c = ShadowsocksConfig.fromJson(cfg);
        _methodCtrl.text = c.method;
        _passwordCtrl.text = c.password;
        break;
      case ProtocolType.vmess:
        final c = VmessConfig.fromJson(cfg);
        _uuidCtrl.text = c.uuid;
        _securityVmess = c.security;
        _transport = c.transport;
        _tls = c.tls;
        _sniCtrl.text = c.sni ?? '';
        _wsPathCtrl.text = c.wsPath ?? '';
        _grpcServiceNameCtrl.text = c.grpcServiceName ?? '';
        _allowInsecure = c.allowInsecure;
        break;
      case ProtocolType.vless:
        final c = VlessConfig.fromJson(cfg);
        _uuidCtrl.text = c.uuid;
        _vlessFlow = c.flow;
        _tls = c.tls;
        _reality = c.reality;
        _sniCtrl.text = c.sni ?? '';
        _publicKeyCtrl.text = c.publicKey ?? '';
        _shortIdCtrl.text = c.shortId ?? '';
        _transport = c.transport;
        _wsPathCtrl.text = c.wsPath ?? '';
        _allowInsecure = c.allowInsecure;
        break;
      case ProtocolType.trojan:
        final c = TrojanConfig.fromJson(cfg);
        _passwordCtrl.text = c.password;
        _tls = c.tls;
        _sniCtrl.text = c.sni ?? '';
        _allowInsecure = c.allowInsecure;
        _transport = c.transport;
        _wsPathCtrl.text = c.wsPath ?? '';
        break;
      case ProtocolType.hysteria2:
        final c = Hysteria2Config.fromJson(cfg);
        _passwordCtrl.text = c.password;
        _sniCtrl.text = c.sni ?? '';
        _allowInsecure = c.allowInsecure;
        break;
      case ProtocolType.tuic:
        final c = TuicConfig.fromJson(cfg);
        _uuidCtrl.text = c.uuid;
        _passwordCtrl.text = c.password;
        _congestionControl = c.congestionControl;
        _sniCtrl.text = c.sni ?? '';
        _allowInsecure = c.allowInsecure;
        break;
      case ProtocolType.wireguard:
        final c = WireGuardConfig.fromJson(cfg);
        _privateKeyCtrl.text = c.privateKey;
        _publicKeyCtrl.text = c.peerPublicKey;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? '添加节点' : '编辑节点'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 协议选择
            _SectionTitle(title: '基础信息'),
            DropdownButtonFormField<ProtocolType>(
              value: _protocolType,
              decoration: const InputDecoration(labelText: '协议类型'),
              items: ProtocolType.values
                  .where((p) => p != ProtocolType.unknown)
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.displayName),
                      ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _protocolType = v ?? ProtocolType.shadowsocks),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '节点名称'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _serverCtrl,
              decoration: const InputDecoration(labelText: '服务器地址'),
              validator: (v) =>
                  (v == null || v.isEmpty) ? '请输入服务器地址' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _portCtrl,
              decoration: const InputDecoration(labelText: '端口'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return '请输入端口';
                final p = int.tryParse(v);
                if (p == null || p < 1 || p > 65535) return '无效端口';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 协议参数
            _SectionTitle(title: '协议参数'),
            ..._buildProtocolFields(),

            const SizedBox(height: 16),
            // TLS/Transport (部分协议)
            if ([
              ProtocolType.vmess,
              ProtocolType.vless,
              ProtocolType.trojan,
            ].contains(_protocolType)) ...[
              _SectionTitle(title: '传输设置'),
              ..._buildTransportFields(),
            ],

            const SizedBox(height: 16),
            _SectionTitle(title: '备注'),
            TextFormField(
              controller: _remarkCtrl,
              decoration: const InputDecoration(labelText: '备注 (可选)'),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProtocolFields() {
    switch (_protocolType) {
      case ProtocolType.shadowsocks:
        return [
          DropdownButtonFormField<String>(
            value: _methodCtrl.text.isEmpty ? 'aes-256-gcm' : _methodCtrl.text,
            decoration: const InputDecoration(labelText: '加密方式'),
            items: [
              'aes-256-gcm',
              'aes-128-gcm',
              'chacha20-ietf-poly1305',
              '2022-blake3-aes-256-gcm',
              '2022-blake3-aes-128-gcm',
              '2022-blake3-chacha20-poly1305',
            ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
            onChanged: (v) => _methodCtrl.text = v ?? 'aes-256-gcm',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: '密码'),
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
          ),
        ];

      case ProtocolType.vmess:
        return [
          TextFormField(
            controller: _uuidCtrl,
            decoration: const InputDecoration(labelText: 'UUID'),
            validator: (v) => (v == null || v.isEmpty) ? '请输入 UUID' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _securityVmess,
            decoration: const InputDecoration(labelText: '加密方式'),
            items: ['auto', 'aes-128-gcm', 'chacha20-poly1305', 'zero', 'none']
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => _securityVmess = v ?? 'auto',
          ),
        ];

      case ProtocolType.vless:
        return [
          TextFormField(
            controller: _uuidCtrl,
            decoration: const InputDecoration(labelText: 'UUID'),
            validator: (v) => (v == null || v.isEmpty) ? '请输入 UUID' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<VlessFlow>(
            value: _vlessFlow,
            decoration: const InputDecoration(labelText: '流控'),
            items: VlessFlow.values
                .map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f == VlessFlow.none ? '无' : 'xtls-rprx-vision'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _vlessFlow = v ?? VlessFlow.none),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _reality,
            onChanged: (v) => setState(() => _reality = v),
            title: const Text('Reality'),
          ),
          if (_reality) ...[
            TextFormField(
              controller: _publicKeyCtrl,
              decoration: const InputDecoration(labelText: 'Public Key'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _shortIdCtrl,
              decoration: const InputDecoration(labelText: 'Short ID'),
            ),
          ],
        ];

      case ProtocolType.trojan:
        return [
          TextFormField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: '密码'),
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
          ),
        ];

      case ProtocolType.hysteria2:
        return [
          TextFormField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: '密码'),
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sniCtrl,
            decoration: const InputDecoration(labelText: 'SNI'),
          ),
        ];

      case ProtocolType.tuic:
        return [
          TextFormField(
            controller: _uuidCtrl,
            decoration: const InputDecoration(labelText: 'UUID'),
            validator: (v) => (v == null || v.isEmpty) ? '请输入 UUID' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: '密码'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _congestionControl,
            decoration: const InputDecoration(labelText: '拥塞控制'),
            items: ['bbr', 'cubic', 'new_reno']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => _congestionControl = v ?? 'bbr',
          ),
        ];

      case ProtocolType.wireguard:
        return [
          TextFormField(
            controller: _privateKeyCtrl,
            decoration: const InputDecoration(labelText: '私钥'),
            validator: (v) => (v == null || v.isEmpty) ? '请输入私钥' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _publicKeyCtrl,
            decoration: const InputDecoration(labelText: '对端公钥'),
            validator: (v) => (v == null || v.isEmpty) ? '请输入公钥' : null,
          ),
        ];

      default:
        return [const Text('此协议暂不支持手动编辑')];
    }
  }

  List<Widget> _buildTransportFields() {
    return [
      SwitchListTile(
        value: _tls,
        onChanged: (v) => setState(() => _tls = v),
        title: const Text('TLS'),
      ),
      if (_tls) ...[
        TextFormField(
          controller: _sniCtrl,
          decoration: const InputDecoration(labelText: 'SNI'),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          value: _allowInsecure,
          onChanged: (v) => setState(() => _allowInsecure = v),
          title: const Text('允许不安全'),
          subtitle: const Text('不验证 TLS 证书'),
        ),
      ],
      const SizedBox(height: 12),
      DropdownButtonFormField<VmessTransport>(
        value: _transport,
        decoration: const InputDecoration(labelText: '传输方式'),
        items: VmessTransport.values
            .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
            .toList(),
        onChanged: (v) => setState(() => _transport = v ?? VmessTransport.tcp),
      ),
      if (_transport == VmessTransport.ws)
        TextFormField(
          controller: _wsPathCtrl,
          decoration: const InputDecoration(labelText: 'WebSocket 路径'),
        ),
      if (_transport == VmessTransport.grpc)
        TextFormField(
          controller: _grpcServiceNameCtrl,
          decoration: const InputDecoration(labelText: 'gRPC Service Name'),
        ),
    ];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final rawConfig = _buildRawConfig();
    final now = DateTime.now();
    final name = _nameCtrl.text.isEmpty
        ? '${_serverCtrl.text}:${_portCtrl.text}'
        : _nameCtrl.text;

    final node = Node(
      id: _node?.id ?? _uuid.v4(),
      displayName: name,
      protocolType: _protocolType,
      server: _serverCtrl.text.trim(),
      port: int.parse(_portCtrl.text.trim()),
      rawConfig: rawConfig,
      remark: _remarkCtrl.text.isEmpty ? null : _remarkCtrl.text,
      sourceType: _node?.sourceType ?? NodeSourceType.manual,
      sourceId: _node?.sourceId,
      tags: _node?.tags ?? [],
      groupIds: _node?.groupIds ?? [],
      enabled: _node?.enabled ?? true,
      isFavorite: _node?.isFavorite ?? false,
      isPinned: _node?.isPinned ?? false,
      detourTargetId: _node?.detourTargetId,
      rawUri: _node?.rawUri,
      metadata: _node?.metadata ?? {},
      createdAt: _node?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(nodeRepositoryProvider).save(node);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isNew ? '节点已创建' : '节点已更新')),
      );
      context.pop();
    }
  }

  Map<String, dynamic> _buildRawConfig() {
    switch (_protocolType) {
      case ProtocolType.shadowsocks:
        return ShadowsocksConfig(
          method: _methodCtrl.text,
          password: _passwordCtrl.text,
        ).toJson();
      case ProtocolType.vmess:
        return VmessConfig(
          uuid: _uuidCtrl.text,
          security: _securityVmess,
          transport: _transport,
          tls: _tls,
          sni: _sniCtrl.text.isEmpty ? null : _sniCtrl.text,
          wsPath: _wsPathCtrl.text.isEmpty ? null : _wsPathCtrl.text,
          grpcServiceName: _grpcServiceNameCtrl.text.isEmpty
              ? null
              : _grpcServiceNameCtrl.text,
          allowInsecure: _allowInsecure,
        ).toJson();
      case ProtocolType.vless:
        return VlessConfig(
          uuid: _uuidCtrl.text,
          flow: _vlessFlow,
          tls: _tls,
          reality: _reality,
          publicKey: _publicKeyCtrl.text.isEmpty ? null : _publicKeyCtrl.text,
          shortId: _shortIdCtrl.text.isEmpty ? null : _shortIdCtrl.text,
          sni: _sniCtrl.text.isEmpty ? null : _sniCtrl.text,
          transport: _transport,
          wsPath: _wsPathCtrl.text.isEmpty ? null : _wsPathCtrl.text,
          allowInsecure: _allowInsecure,
        ).toJson();
      case ProtocolType.trojan:
        return TrojanConfig(
          password: _passwordCtrl.text,
          tls: _tls,
          sni: _sniCtrl.text.isEmpty ? null : _sniCtrl.text,
          allowInsecure: _allowInsecure,
          transport: _transport,
          wsPath: _wsPathCtrl.text.isEmpty ? null : _wsPathCtrl.text,
        ).toJson();
      case ProtocolType.hysteria2:
        return Hysteria2Config(
          password: _passwordCtrl.text,
          sni: _sniCtrl.text.isEmpty ? null : _sniCtrl.text,
          allowInsecure: _allowInsecure,
        ).toJson();
      case ProtocolType.tuic:
        return TuicConfig(
          uuid: _uuidCtrl.text,
          password: _passwordCtrl.text,
          congestionControl: _congestionControl,
          sni: _sniCtrl.text.isEmpty ? null : _sniCtrl.text,
          allowInsecure: _allowInsecure,
        ).toJson();
      case ProtocolType.wireguard:
        return WireGuardConfig(
          privateKey: _privateKeyCtrl.text,
          peerPublicKey: _publicKeyCtrl.text,
        ).toJson();
      default:
        return {};
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _serverCtrl.dispose();
    _portCtrl.dispose();
    _remarkCtrl.dispose();
    _passwordCtrl.dispose();
    _uuidCtrl.dispose();
    _methodCtrl.dispose();
    _sniCtrl.dispose();
    _wsPathCtrl.dispose();
    _grpcServiceNameCtrl.dispose();
    _privateKeyCtrl.dispose();
    _publicKeyCtrl.dispose();
    _shortIdCtrl.dispose();
    super.dispose();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
