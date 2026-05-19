// 节点协议类型
enum ProtocolType {
  socks('socks', 'SOCKS'),
  http('http', 'HTTP'),
  shadowsocks('shadowsocks', 'Shadowsocks'),
  vmess('vmess', 'VMess'),
  vless('vless', 'VLESS'),
  trojan('trojan', 'Trojan'),
  hysteria2('hysteria2', 'Hysteria2'),
  tuic('tuic', 'TUIC'),
  wireguard('wireguard', 'WireGuard'),
  ssh('ssh', 'SSH'),
  unknown('unknown', '未知');

  final String value;
  final String displayName;
  const ProtocolType(this.value, this.displayName);

  static ProtocolType fromString(String value) {
    return ProtocolType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => ProtocolType.unknown,
    );
  }

  static ProtocolType fromUri(String uri) {
    final lower = uri.toLowerCase();
    if (lower.startsWith('ss://')) return ProtocolType.shadowsocks;
    if (lower.startsWith('vmess://')) return ProtocolType.vmess;
    if (lower.startsWith('vless://')) return ProtocolType.vless;
    if (lower.startsWith('trojan://')) return ProtocolType.trojan;
    if (lower.startsWith('hysteria2://') || lower.startsWith('hy2://')) {
      return ProtocolType.hysteria2;
    }
    if (lower.startsWith('tuic://')) return ProtocolType.tuic;
    if (lower.startsWith('socks://') || lower.startsWith('socks5://')) {
      return ProtocolType.socks;
    }
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return ProtocolType.http;
    }
    return ProtocolType.unknown;
  }
}
