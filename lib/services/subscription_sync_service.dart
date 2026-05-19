import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/node/node.dart';
import '../models/protocol_type.dart';
import '../models/subscription/subscription.dart';
import '../models/node_source_type.dart';
import '../utils/uri_parser.dart';

const _uuid = Uuid();

class SubscriptionSyncResult {
  final int added;
  final int updated;
  final int removed;
  final int failed;
  final String? error;

  const SubscriptionSyncResult({
    this.added = 0,
    this.updated = 0,
    this.removed = 0,
    this.failed = 0,
    this.error,
  });
}

class SubscriptionSyncService {
  final Dio _dio;

  SubscriptionSyncService() : _dio = Dio();

  /// 拉取并解析订阅
  Future<({SubscriptionSyncResult result, List<Node> nodes})> fetchAndParse(
    Subscription subscription,
  ) async {
    try {
      final response = await _dio.get<String>(
        subscription.url,
        options: Options(
          headers: {
            'User-Agent': subscription.userAgent ??
                'Mozilla/5.0 FLSingBox/0.1',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode != 200 || response.data == null) {
        return (
          result: SubscriptionSyncResult(
            error: 'HTTP ${response.statusCode}',
          ),
          nodes: <Node>[],
        );
      }

      final content = response.data!;
      final nodes = _parseContent(content, subscription);

      return (
        result: SubscriptionSyncResult(added: nodes.length),
        nodes: nodes,
      );
    } on DioException catch (e) {
      return (
        result: SubscriptionSyncResult(error: '网络错误: ${e.message}'),
        nodes: <Node>[],
      );
    } catch (e) {
      return (
        result: SubscriptionSyncResult(error: '解析失败: $e'),
        nodes: <Node>[],
      );
    }
  }

  List<Node> _parseContent(String content, Subscription subscription) {
    final trimmed = content.trim();

    // 尝试 Base64 解码
    String decoded = trimmed;
    try {
      final padded = trimmed.length % 4 == 0
          ? trimmed
          : trimmed + '=' * (4 - trimmed.length % 4);
      decoded = utf8.decode(base64.decode(padded));
    } catch (_) {
      // 非 base64, 保持原文
    }

    // 尝试解析为 URI 列表
    final lines = decoded
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && _isProxyUri(l))
        .toList();

    if (lines.isNotEmpty) {
      final results = NodeUriParser.parseMultiple(
        lines.join('\n'),
        sourceType: NodeSourceType.subscription,
        sourceId: subscription.id,
      );
      return results.where((r) => r.success).map((r) => r.node!).toList();
    }

    // 尝试解析为 sing-box 格式
    try {
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      if (json.containsKey('outbounds')) {
        return _parseSingBoxConfig(json, subscription);
      }
    } catch (_) {}

    return [];
  }

  bool _isProxyUri(String line) {
    return line.startsWith('ss://') ||
        line.startsWith('vmess://') ||
        line.startsWith('vless://') ||
        line.startsWith('trojan://') ||
        line.startsWith('hysteria2://') ||
        line.startsWith('hy2://') ||
        line.startsWith('tuic://') ||
        line.startsWith('socks://') ||
        line.startsWith('socks5://');
  }

  List<Node> _parseSingBoxConfig(
    Map<String, dynamic> config,
    Subscription subscription,
  ) {
    final outbounds = config['outbounds'] as List<dynamic>? ?? [];
    final nodes = <Node>[];
    final now = DateTime.now();

    for (final outbound in outbounds) {
      if (outbound is! Map<String, dynamic>) continue;
      final type = outbound['type'] as String? ?? '';
      if (['selector', 'urltest', 'direct', 'block', 'dns'].contains(type)) {
        continue;
      }

      final server = outbound['server'] as String? ?? '';
      final port = outbound['server_port'] as int? ?? 0;
      if (server.isEmpty || port == 0) continue;

      nodes.add(
        Node(
          id: _uuid.v4(),
          displayName: outbound['tag'] as String? ?? '$server:$port',
          protocolType: ProtocolType.fromString(type),
          server: server,
          port: port,
          rawConfig: outbound,
          sourceType: NodeSourceType.subscription,
          sourceId: subscription.id,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    return nodes;
  }
}

final subscriptionSyncServiceProvider = Provider(
  (_) => SubscriptionSyncService(),
);
