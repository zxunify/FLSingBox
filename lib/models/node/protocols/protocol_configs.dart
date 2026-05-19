// Shadowsocks 配置
class ShadowsocksConfig {
  final String method;
  final String password;
  final String? plugin;
  final String? pluginOpts;
  final bool udpOverTcp;

  const ShadowsocksConfig({
    required this.method,
    required this.password,
    this.plugin,
    this.pluginOpts,
    this.udpOverTcp = false,
  });

  factory ShadowsocksConfig.fromJson(Map<String, dynamic> json) =>
      ShadowsocksConfig(
        method: json['method'] as String? ?? 'aes-256-gcm',
        password: json['password'] as String? ?? '',
        plugin: json['plugin'] as String?,
        pluginOpts: json['plugin_opts'] as String?,
        udpOverTcp: json['udp_over_tcp'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'method': method,
        'password': password,
        if (plugin != null) 'plugin': plugin,
        if (pluginOpts != null) 'plugin_opts': pluginOpts,
        'udp_over_tcp': udpOverTcp,
      };

  ShadowsocksConfig copyWith({
    String? method,
    String? password,
    String? plugin,
    String? pluginOpts,
    bool? udpOverTcp,
  }) =>
      ShadowsocksConfig(
        method: method ?? this.method,
        password: password ?? this.password,
        plugin: plugin ?? this.plugin,
        pluginOpts: pluginOpts ?? this.pluginOpts,
        udpOverTcp: udpOverTcp ?? this.udpOverTcp,
      );
}

// VMess 传输层类型
enum VmessTransport {
  tcp,
  ws,
  grpc,
  quic,
  h2,
}

// VMess 配置
class VmessConfig {
  final String uuid;
  final String security;
  final int alterId;
  final VmessTransport transport;
  final bool tls;
  final String? sni;
  final String? wsPath;
  final Map<String, String> wsHeaders;
  final String? grpcServiceName;
  final bool allowInsecure;

  const VmessConfig({
    required this.uuid,
    this.security = 'auto',
    this.alterId = 0,
    this.transport = VmessTransport.tcp,
    this.tls = false,
    this.sni,
    this.wsPath,
    this.wsHeaders = const {},
    this.grpcServiceName,
    this.allowInsecure = false,
  });

  factory VmessConfig.fromJson(Map<String, dynamic> json) => VmessConfig(
        uuid: json['uuid'] as String? ?? '',
        security: json['security'] as String? ?? 'auto',
        alterId: json['alter_id'] as int? ?? 0,
        transport: VmessTransport.values.firstWhere(
          (e) => e.name == (json['transport'] as String? ?? 'tcp'),
          orElse: () => VmessTransport.tcp,
        ),
        tls: json['tls'] as bool? ?? false,
        sni: json['sni'] as String?,
        wsPath: json['ws_path'] as String?,
        wsHeaders:
            (json['ws_headers'] as Map<String, dynamic>?)?.cast<String, String>() ??
                {},
        grpcServiceName: json['grpc_service_name'] as String?,
        allowInsecure: json['allow_insecure'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'security': security,
        'alter_id': alterId,
        'transport': transport.name,
        'tls': tls,
        if (sni != null) 'sni': sni,
        if (wsPath != null) 'ws_path': wsPath,
        if (wsHeaders.isNotEmpty) 'ws_headers': wsHeaders,
        if (grpcServiceName != null) 'grpc_service_name': grpcServiceName,
        'allow_insecure': allowInsecure,
      };
}

// VLESS 流控类型
enum VlessFlow { none, xtlsRprxVision }

// VLESS 配置
class VlessConfig {
  final String uuid;
  final VlessFlow flow;
  final bool tls;
  final bool reality;
  final String? publicKey;
  final String? shortId;
  final String? serverName;
  final String? sni;
  final VmessTransport transport;
  final String? wsPath;
  final bool allowInsecure;

  const VlessConfig({
    required this.uuid,
    this.flow = VlessFlow.none,
    this.tls = false,
    this.reality = false,
    this.publicKey,
    this.shortId,
    this.serverName,
    this.sni,
    this.transport = VmessTransport.tcp,
    this.wsPath,
    this.allowInsecure = false,
  });

  factory VlessConfig.fromJson(Map<String, dynamic> json) => VlessConfig(
        uuid: json['uuid'] as String? ?? '',
        flow: VlessFlow.values.firstWhere(
          (e) => e.name == (json['flow'] as String? ?? 'none'),
          orElse: () => VlessFlow.none,
        ),
        tls: json['tls'] as bool? ?? false,
        reality: json['reality'] as bool? ?? false,
        publicKey: json['public_key'] as String?,
        shortId: json['short_id'] as String?,
        serverName: json['server_name'] as String?,
        sni: json['sni'] as String?,
        transport: VmessTransport.values.firstWhere(
          (e) => e.name == (json['transport'] as String? ?? 'tcp'),
          orElse: () => VmessTransport.tcp,
        ),
        wsPath: json['ws_path'] as String?,
        allowInsecure: json['allow_insecure'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'flow': flow.name,
        'tls': tls,
        'reality': reality,
        if (publicKey != null) 'public_key': publicKey,
        if (shortId != null) 'short_id': shortId,
        if (serverName != null) 'server_name': serverName,
        if (sni != null) 'sni': sni,
        'transport': transport.name,
        if (wsPath != null) 'ws_path': wsPath,
        'allow_insecure': allowInsecure,
      };
}

// Trojan 配置
class TrojanConfig {
  final String password;
  final bool tls;
  final String? sni;
  final List<String> alpn;
  final bool allowInsecure;
  final VmessTransport transport;
  final String? wsPath;

  const TrojanConfig({
    required this.password,
    this.tls = true,
    this.sni,
    this.alpn = const [],
    this.allowInsecure = false,
    this.transport = VmessTransport.tcp,
    this.wsPath,
  });

  factory TrojanConfig.fromJson(Map<String, dynamic> json) => TrojanConfig(
        password: json['password'] as String? ?? '',
        tls: json['tls'] as bool? ?? true,
        sni: json['sni'] as String?,
        alpn: (json['alpn'] as List<dynamic>?)?.cast<String>() ?? [],
        allowInsecure: json['allow_insecure'] as bool? ?? false,
        transport: VmessTransport.values.firstWhere(
          (e) => e.name == (json['transport'] as String? ?? 'tcp'),
          orElse: () => VmessTransport.tcp,
        ),
        wsPath: json['ws_path'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'password': password,
        'tls': tls,
        if (sni != null) 'sni': sni,
        if (alpn.isNotEmpty) 'alpn': alpn,
        'allow_insecure': allowInsecure,
        'transport': transport.name,
        if (wsPath != null) 'ws_path': wsPath,
      };
}

// Hysteria2 配置
class Hysteria2Config {
  final String password;
  final String? obfs;
  final String? obfsPassword;
  final bool tls;
  final String? sni;
  final List<String> alpn;
  final bool allowInsecure;

  const Hysteria2Config({
    required this.password,
    this.obfs,
    this.obfsPassword,
    this.tls = true,
    this.sni,
    this.alpn = const [],
    this.allowInsecure = false,
  });

  factory Hysteria2Config.fromJson(Map<String, dynamic> json) => Hysteria2Config(
        password: json['password'] as String? ?? '',
        obfs: json['obfs'] as String?,
        obfsPassword: json['obfs_password'] as String?,
        tls: json['tls'] as bool? ?? true,
        sni: json['sni'] as String?,
        alpn: (json['alpn'] as List<dynamic>?)?.cast<String>() ?? [],
        allowInsecure: json['allow_insecure'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'password': password,
        if (obfs != null) 'obfs': obfs,
        if (obfsPassword != null) 'obfs_password': obfsPassword,
        'tls': tls,
        if (sni != null) 'sni': sni,
        if (alpn.isNotEmpty) 'alpn': alpn,
        'allow_insecure': allowInsecure,
      };
}

// TUIC 配置
class TuicConfig {
  final String uuid;
  final String password;
  final String congestionControl;
  final List<String> alpn;
  final String? sni;
  final bool allowInsecure;

  const TuicConfig({
    required this.uuid,
    required this.password,
    this.congestionControl = 'bbr',
    this.alpn = const ['h3'],
    this.sni,
    this.allowInsecure = false,
  });

  factory TuicConfig.fromJson(Map<String, dynamic> json) => TuicConfig(
        uuid: json['uuid'] as String? ?? '',
        password: json['password'] as String? ?? '',
        congestionControl:
            json['congestion_control'] as String? ?? 'bbr',
        alpn: (json['alpn'] as List<dynamic>?)?.cast<String>() ?? ['h3'],
        sni: json['sni'] as String?,
        allowInsecure: json['allow_insecure'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'password': password,
        'congestion_control': congestionControl,
        'alpn': alpn,
        if (sni != null) 'sni': sni,
        'allow_insecure': allowInsecure,
      };
}

// WireGuard 配置
class WireGuardConfig {
  final String privateKey;
  final String peerPublicKey;
  final String? preSharedKey;
  final List<String> localAddresses;
  final List<int> reserved;
  final int mtu;
  final List<String> peerAllowedIps;

  const WireGuardConfig({
    required this.privateKey,
    required this.peerPublicKey,
    this.preSharedKey,
    this.localAddresses = const ['10.0.0.2/32', 'fd00::2/128'],
    this.reserved = const [0, 0, 0],
    this.mtu = 1408,
    this.peerAllowedIps = const ['0.0.0.0/0', '::/0'],
  });

  factory WireGuardConfig.fromJson(Map<String, dynamic> json) => WireGuardConfig(
        privateKey: json['private_key'] as String? ?? '',
        peerPublicKey: json['peer_public_key'] as String? ?? '',
        preSharedKey: json['pre_shared_key'] as String?,
        localAddresses:
            (json['local_addresses'] as List<dynamic>?)?.cast<String>() ??
                ['10.0.0.2/32'],
        reserved:
            (json['reserved'] as List<dynamic>?)?.cast<int>() ?? [0, 0, 0],
        mtu: json['mtu'] as int? ?? 1408,
        peerAllowedIps:
            (json['peer_allowed_ips'] as List<dynamic>?)?.cast<String>() ??
                ['0.0.0.0/0', '::/0'],
      );

  Map<String, dynamic> toJson() => {
        'private_key': privateKey,
        'peer_public_key': peerPublicKey,
        if (preSharedKey != null) 'pre_shared_key': preSharedKey,
        'local_addresses': localAddresses,
        'reserved': reserved,
        'mtu': mtu,
        'peer_allowed_ips': peerAllowedIps,
      };
}

// SOCKS/HTTP 配置
class SocksHttpConfig {
  final String? username;
  final String? password;
  final int version; // 4, 5

  const SocksHttpConfig({
    this.username,
    this.password,
    this.version = 5,
  });

  factory SocksHttpConfig.fromJson(Map<String, dynamic> json) => SocksHttpConfig(
        username: json['username'] as String?,
        password: json['password'] as String?,
        version: json['version'] as int? ?? 5,
      );

  Map<String, dynamic> toJson() => {
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        'version': version,
      };
}
