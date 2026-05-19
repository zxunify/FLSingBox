import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../models/node/node.dart';
import '../../models/node/protocols/protocol_configs.dart';
import '../../models/protocol_type.dart';
import '../../models/node_source_type.dart';

const _uuid = Uuid();

/// URI 解析结果
class UriParseResult {
  final Node? node;
  final String? error;
  final String rawUri;

  const UriParseResult({this.node, this.error, required this.rawUri});
  bool get success => node != null;
}

/// 通用 URI 解析器入口
class NodeUriParser {
  static UriParseResult parse(
    String rawUri, {
    NodeSourceType sourceType = NodeSourceType.manual,
    String? sourceId,
  }) {
    final trimmed = rawUri.trim();
    if (trimmed.isEmpty) {
      return UriParseResult(error: '空行', rawUri: rawUri);
    }

    try {
      final type = ProtocolType.fromUri(trimmed);
      switch (type) {
        case ProtocolType.shadowsocks:
          return ShadowsocksUriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.vmess:
          return VmessUriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.vless:
          return VlessUriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.trojan:
          return TrojanUriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.hysteria2:
          return Hysteria2UriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.tuic:
          return TuicUriParser.parse(trimmed, sourceType, sourceId);
        case ProtocolType.socks:
          return SocksUriParser.parse(trimmed, sourceType, sourceId);
        default:
          return UriParseResult(
            error: '不支持的协议类型',
            rawUri: rawUri,
          );
      }
    } catch (e) {
      return UriParseResult(error: '解析失败: $e', rawUri: rawUri);
    }
  }

  /// 批量解析多行 URI
  static List<UriParseResult> parseMultiple(
    String text, {
    NodeSourceType sourceType = NodeSourceType.manual,
    String? sourceId,
  }) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return lines
        .map((line) => parse(line, sourceType: sourceType, sourceId: sourceId))
        .toList();
  }
}

Node _buildNode({
  required String displayName,
  required ProtocolType protocolType,
  required String server,
  required int port,
  required Map<String, dynamic> rawConfig,
  required String rawUri,
  NodeSourceType sourceType = NodeSourceType.manual,
  String? sourceId,
}) {
  final now = DateTime.now();
  return Node(
    id: _uuid.v4(),
    displayName: displayName.isEmpty ? '$server:$port' : displayName,
    protocolType: protocolType,
    server: server,
    port: port,
    rawConfig: rawConfig,
    rawUri: rawUri,
    sourceType: sourceType,
    sourceId: sourceId,
    createdAt: now,
    updatedAt: now,
  );
}

/// Shadowsocks URI 解析器
/// 格式: ss://BASE64(method:password)@server:port#name
///    or ss://BASE64(method:password@server:port)#name (旧格式)
class ShadowsocksUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      // 去掉 ss:// 前缀
      var rest = uri.substring(5);

      // 提取 name (fragment)
      String name = '';
      final hashIdx = rest.indexOf('#');
      if (hashIdx != -1) {
        name = Uri.decodeComponent(rest.substring(hashIdx + 1));
        rest = rest.substring(0, hashIdx);
      }

      String method, password, server;
      int port;

      if (rest.contains('@')) {
        // 新格式: BASE64(method:password)@server:port
        final atIdx = rest.lastIndexOf('@');
        final userInfoEncoded = rest.substring(0, atIdx);
        final serverPart = rest.substring(atIdx + 1);

        // 解码用户信息
        String userInfo;
        try {
          userInfo = utf8.decode(base64.decode(_padBase64(userInfoEncoded)));
        } catch (_) {
          userInfo = Uri.decodeComponent(userInfoEncoded);
        }

        final colonIdx = userInfo.indexOf(':');
        if (colonIdx == -1) throw Exception('Invalid userInfo');
        method = userInfo.substring(0, colonIdx);
        password = userInfo.substring(colonIdx + 1);

        final serverUri = Uri.parse('tcp://$serverPart');
        server = serverUri.host;
        port = serverUri.port;
      } else {
        // 旧格式: BASE64(method:password@server:port)
        final decoded = utf8.decode(base64.decode(_padBase64(rest)));
        final atIdx = decoded.lastIndexOf('@');
        if (atIdx == -1) throw Exception('Invalid SS URI');

        final userInfo = decoded.substring(0, atIdx);
        final serverPart = decoded.substring(atIdx + 1);

        final colonIdx = userInfo.indexOf(':');
        method = userInfo.substring(0, colonIdx);
        password = userInfo.substring(colonIdx + 1);

        final parts = serverPart.split(':');
        server = parts[0];
        port = int.parse(parts[1]);
      }

      final cfg = ShadowsocksConfig(method: method, password: password);
      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.shadowsocks,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'SS 解析失败: $e', rawUri: uri);
    }
  }
}

/// VMess URI 解析器 (V2Ray 格式: vmess://BASE64(JSON))
class VmessUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      final encoded = uri.substring(8); // remove vmess://
      final decoded = utf8.decode(base64.decode(_padBase64(encoded)));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      final server = json['add'] as String? ?? '';
      final port = int.tryParse(json['port']?.toString() ?? '0') ?? 0;
      final name = json['ps'] as String? ?? '$server:$port';

      final transport = _mapNet(json['net'] as String? ?? 'tcp');
      final cfg = VmessConfig(
        uuid: json['id'] as String? ?? '',
        security: json['scy'] as String? ?? json['security'] as String? ?? 'auto',
        alterId: int.tryParse(json['aid']?.toString() ?? '0') ?? 0,
        transport: transport,
        tls: (json['tls'] as String? ?? '') == 'tls',
        sni: json['sni'] as String? ?? json['host'] as String?,
        wsPath: json['path'] as String?,
        grpcServiceName: json['path'] as String?,
        allowInsecure: false,
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.vmess,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'VMess 解析失败: $e', rawUri: uri);
    }
  }

  static VmessTransport _mapNet(String net) {
    switch (net) {
      case 'ws':
        return VmessTransport.ws;
      case 'grpc':
        return VmessTransport.grpc;
      case 'h2':
        return VmessTransport.h2;
      default:
        return VmessTransport.tcp;
    }
  }
}

/// VLESS URI 解析器
/// vless://uuid@server:port?type=tcp&security=tls&sni=...#name
class VlessUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      final parsed = Uri.parse(uri);
      final uuid = parsed.userInfo;
      final server = parsed.host;
      final port = parsed.port;
      final name = Uri.decodeComponent(parsed.fragment);
      final params = parsed.queryParameters;

      final security = params['security'] ?? 'none';
      final flow = params['flow'] ?? '';
      final transport = _mapType(params['type'] ?? 'tcp');

      final cfg = VlessConfig(
        uuid: uuid,
        flow: flow == 'xtls-rprx-vision'
            ? VlessFlow.xtlsRprxVision
            : VlessFlow.none,
        tls: security == 'tls',
        reality: security == 'reality',
        publicKey: params['pbk'],
        shortId: params['sid'],
        serverName: params['sni'],
        sni: params['sni'],
        transport: transport,
        wsPath: params['path'],
        allowInsecure: params['allowInsecure'] == '1',
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.vless,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'VLESS 解析失败: $e', rawUri: uri);
    }
  }

  static VmessTransport _mapType(String type) {
    switch (type) {
      case 'ws':
        return VmessTransport.ws;
      case 'grpc':
        return VmessTransport.grpc;
      case 'h2':
      case 'http':
        return VmessTransport.h2;
      default:
        return VmessTransport.tcp;
    }
  }
}

/// Trojan URI 解析器
/// trojan://password@server:port?sni=...#name
class TrojanUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      final parsed = Uri.parse(uri);
      final password = parsed.userInfo;
      final server = parsed.host;
      final port = parsed.port;
      final name = Uri.decodeComponent(parsed.fragment);
      final params = parsed.queryParameters;

      final cfg = TrojanConfig(
        password: password,
        tls: true,
        sni: params['sni'] ?? params['peer'],
        alpn: params['alpn']?.split(',') ?? [],
        allowInsecure: params['allowInsecure'] == '1',
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.trojan,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'Trojan 解析失败: $e', rawUri: uri);
    }
  }
}

/// Hysteria2 URI 解析器
/// hysteria2://password@server:port?sni=...&obfs=...#name
class Hysteria2UriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      // hy2:// 别名兼容
      final normalized = uri.replaceFirst('hy2://', 'hysteria2://');
      final parsed = Uri.parse(normalized);
      final password = parsed.userInfo;
      final server = parsed.host;
      final port = parsed.port;
      final name = Uri.decodeComponent(parsed.fragment);
      final params = parsed.queryParameters;

      final cfg = Hysteria2Config(
        password: password,
        obfs: params['obfs'],
        obfsPassword: params['obfs-password'] ?? params['obfsPassword'],
        tls: true,
        sni: params['sni'],
        allowInsecure: params['insecure'] == '1',
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.hysteria2,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'Hysteria2 解析失败: $e', rawUri: uri);
    }
  }
}

/// TUIC URI 解析器
/// tuic://uuid:password@server:port?sni=...&congestion_control=bbr#name
class TuicUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      final parsed = Uri.parse(uri);
      final userInfo = parsed.userInfo;
      final colonIdx = userInfo.indexOf(':');
      final uuid = colonIdx == -1 ? userInfo : userInfo.substring(0, colonIdx);
      final password = colonIdx == -1 ? '' : userInfo.substring(colonIdx + 1);
      final server = parsed.host;
      final port = parsed.port;
      final name = Uri.decodeComponent(parsed.fragment);
      final params = parsed.queryParameters;

      final cfg = TuicConfig(
        uuid: uuid,
        password: password,
        congestionControl: params['congestion_control'] ?? 'bbr',
        alpn: params['alpn']?.split(',') ?? ['h3'],
        sni: params['sni'],
        allowInsecure: params['allow_insecure'] == '1',
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.tuic,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'TUIC 解析失败: $e', rawUri: uri);
    }
  }
}

/// SOCKS URI 解析器
/// socks5://user:pass@server:port#name
class SocksUriParser {
  static UriParseResult parse(
    String uri,
    NodeSourceType sourceType,
    String? sourceId,
  ) {
    try {
      final parsed = Uri.parse(uri);
      final userInfo = parsed.userInfo;
      final colonIdx = userInfo.indexOf(':');
      final username = colonIdx == -1 ? userInfo : userInfo.substring(0, colonIdx);
      final password = colonIdx == -1 ? '' : userInfo.substring(colonIdx + 1);
      final server = parsed.host;
      final port = parsed.port;
      final name = Uri.decodeComponent(parsed.fragment);

      final cfg = SocksHttpConfig(
        username: username.isEmpty ? null : username,
        password: password.isEmpty ? null : password,
        version: uri.startsWith('socks4') ? 4 : 5,
      );

      final node = _buildNode(
        displayName: name,
        protocolType: ProtocolType.socks,
        server: server,
        port: port,
        rawConfig: cfg.toJson(),
        rawUri: uri,
        sourceType: sourceType,
        sourceId: sourceId,
      );

      return UriParseResult(node: node, rawUri: uri);
    } catch (e) {
      return UriParseResult(error: 'SOCKS 解析失败: $e', rawUri: uri);
    }
  }
}

String _padBase64(String s) {
  final pad = s.length % 4;
  if (pad == 0) return s;
  return s + '=' * (4 - pad);
}
