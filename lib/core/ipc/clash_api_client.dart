import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// sing-box Clash 兼容 API 客户端
/// 通过 sing-box 内置的 HTTP 控制接口与核心通信
class ClashApiClient {
  final Dio _dio;
  final String _baseUrl;
  final String? _secret;
  StreamSubscription? _trafficSub;
  StreamSubscription? _logSub;

  ClashApiClient({
    String host = '127.0.0.1',
    int port = 9090,
    String? secret,
  })  : _baseUrl = 'http://$host:$port',
        _secret = secret,
        _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    if (secret != null && secret.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $secret';
    }
  }

  /// 更新连接参数
  void updateConnection({String? host, int? port, String? secret}) {
    if (host != null || port != null) {
      _dio.options.baseUrl = 'http://${host ?? '127.0.0.1'}:${port ?? 9090}';
    }
    if (secret != null) {
      _dio.options.headers['Authorization'] = 'Bearer $secret';
    }
  }

  /// 检查 API 是否可用
  Future<bool> isAvailable() async {
    try {
      final resp = await _dio.get('$_baseUrl/');
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// 等待 API 就绪
  Future<bool> waitForReady({Duration timeout = const Duration(seconds: 10)}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await isAvailable()) return true;
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return false;
  }

  // === 流量信息 ===

  /// 获取实时流量（单次）
  Future<TrafficData?> getTraffic() async {
    try {
      final resp = await _dio.get('$_baseUrl/traffic');
      if (resp.statusCode == 200) {
        return TrafficData.fromJson(resp.data);
      }
    } catch (e) {
      _logger.d('获取流量失败: $e');
    }
    return null;
  }

  /// 订阅实时流量流
  Stream<TrafficData> trafficStream() async* {
    try {
      final resp = await _dio.get<ResponseBody>(
        '$_baseUrl/traffic',
        options: Options(responseType: ResponseType.stream),
      );
      await for (final chunk in resp.data!.stream) {
        final lines = utf8.decode(chunk).split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          try {
            yield TrafficData.fromJson(jsonDecode(line));
          } catch (_) {}
        }
      }
    } catch (e) {
      _logger.d('流量流中断: $e');
    }
  }

  // === 连接管理 ===

  /// 获取所有活跃连接
  Future<ConnectionsData?> getConnections() async {
    try {
      final resp = await _dio.get('$_baseUrl/connections');
      if (resp.statusCode == 200) {
        return ConnectionsData.fromJson(resp.data);
      }
    } catch (e) {
      _logger.d('获取连接失败: $e');
    }
    return null;
  }

  /// 关闭指定连接
  Future<bool> closeConnection(String id) async {
    try {
      final resp = await _dio.delete('$_baseUrl/connections/$id');
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  /// 关闭所有连接
  Future<bool> closeAllConnections() async {
    try {
      final resp = await _dio.delete('$_baseUrl/connections');
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  // === 代理/出站 ===

  /// 获取所有代理组
  Future<Map<String, ProxyGroup>?> getProxies() async {
    try {
      final resp = await _dio.get('$_baseUrl/proxies');
      if (resp.statusCode == 200) {
        final proxies = <String, ProxyGroup>{};
        final data = resp.data['proxies'] as Map<String, dynamic>? ?? {};
        for (final entry in data.entries) {
          proxies[entry.key] = ProxyGroup.fromJson(entry.value);
        }
        return proxies;
      }
    } catch (e) {
      _logger.d('获取代理列表失败: $e');
    }
    return null;
  }

  /// 获取指定代理组详情
  Future<ProxyGroup?> getProxy(String name) async {
    try {
      final resp = await _dio.get('$_baseUrl/proxies/${Uri.encodeComponent(name)}');
      if (resp.statusCode == 200) {
        return ProxyGroup.fromJson(resp.data);
      }
    } catch (e) {
      _logger.d('获取代理详情失败: $e');
    }
    return null;
  }

  /// 切换代理组中的节点
  Future<bool> selectProxy(String groupName, String proxyName) async {
    try {
      final resp = await _dio.put(
        '$_baseUrl/proxies/${Uri.encodeComponent(groupName)}',
        data: {'name': proxyName},
      );
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  /// 测试代理延迟
  Future<int?> testProxyDelay(
    String proxyName, {
    String testUrl = 'http://www.gstatic.com/generate_204',
    int timeout = 5000,
  }) async {
    try {
      final resp = await _dio.get(
        '$_baseUrl/proxies/${Uri.encodeComponent(proxyName)}/delay',
        queryParameters: {'url': testUrl, 'timeout': timeout},
      );
      if (resp.statusCode == 200) {
        return resp.data['delay'] as int?;
      }
    } catch (_) {}
    return null;
  }

  // === 规则 ===

  /// 获取路由规则列表
  Future<List<RuleInfo>?> getRules() async {
    try {
      final resp = await _dio.get('$_baseUrl/rules');
      if (resp.statusCode == 200) {
        final rules = (resp.data['rules'] as List?)
            ?.map((r) => RuleInfo.fromJson(r))
            .toList();
        return rules;
      }
    } catch (e) {
      _logger.d('获取规则失败: $e');
    }
    return null;
  }

  // === 日志 ===

  /// 订阅实时日志流
  Stream<ClashLogEntry> logStream({String level = 'info'}) async* {
    try {
      final resp = await _dio.get<ResponseBody>(
        '$_baseUrl/logs',
        queryParameters: {'level': level},
        options: Options(responseType: ResponseType.stream),
      );
      await for (final chunk in resp.data!.stream) {
        final lines = utf8.decode(chunk).split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          try {
            yield ClashLogEntry.fromJson(jsonDecode(line));
          } catch (_) {}
        }
      }
    } catch (e) {
      _logger.d('日志流中断: $e');
    }
  }

  // === 配置 ===

  /// 获取当前核心配置
  Future<Map<String, dynamic>?> getConfig() async {
    try {
      final resp = await _dio.get('$_baseUrl/configs');
      if (resp.statusCode == 200) {
        return resp.data as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  /// 热更新配置
  Future<bool> patchConfig(Map<String, dynamic> patch) async {
    try {
      final resp = await _dio.patch('$_baseUrl/configs', data: patch);
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  /// 重载配置文件
  Future<bool> reloadConfig(String path) async {
    try {
      final resp = await _dio.put(
        '$_baseUrl/configs',
        queryParameters: {'force': true},
        data: {'path': path},
      );
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  // === 内存 ===

  /// 获取内存使用
  Future<int?> getMemory() async {
    try {
      final resp = await _dio.get('$_baseUrl/memory');
      if (resp.statusCode == 200) {
        return resp.data['inuse'] as int?;
      }
    } catch (_) {}
    return null;
  }

  /// 触发 GC
  Future<bool> gc() async {
    try {
      final resp = await _dio.put('$_baseUrl/cache/flushdns');
      return resp.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _trafficSub?.cancel();
    _logSub?.cancel();
    _dio.close();
  }
}

// === 数据模型 ===

class TrafficData {
  final int up;
  final int down;

  const TrafficData({required this.up, required this.down});

  factory TrafficData.fromJson(Map<String, dynamic> json) => TrafficData(
        up: json['up'] as int? ?? 0,
        down: json['down'] as int? ?? 0,
      );

  String get upFormatted => _formatBytes(up);
  String get downFormatted => _formatBytes(down);

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B/s';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB/s';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB/s';
    }
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB/s';
  }
}

class ConnectionsData {
  final int downloadTotal;
  final int uploadTotal;
  final List<ConnectionInfo> connections;

  const ConnectionsData({
    required this.downloadTotal,
    required this.uploadTotal,
    required this.connections,
  });

  factory ConnectionsData.fromJson(Map<String, dynamic> json) =>
      ConnectionsData(
        downloadTotal: json['downloadTotal'] as int? ?? 0,
        uploadTotal: json['uploadTotal'] as int? ?? 0,
        connections: (json['connections'] as List?)
                ?.map((c) => ConnectionInfo.fromJson(c))
                .toList() ??
            [],
      );
}

class ConnectionInfo {
  final String id;
  final String destinationIP;
  final String destinationPort;
  final String network;
  final String type;
  final String host;
  final String rule;
  final String rulePayload;
  final String chains;
  final int download;
  final int upload;
  final DateTime start;

  const ConnectionInfo({
    required this.id,
    required this.destinationIP,
    required this.destinationPort,
    required this.network,
    required this.type,
    required this.host,
    required this.rule,
    required this.rulePayload,
    required this.chains,
    required this.download,
    required this.upload,
    required this.start,
  });

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return ConnectionInfo(
      id: json['id'] as String? ?? '',
      destinationIP: metadata['destinationIP'] as String? ?? '',
      destinationPort: metadata['destinationPort'] as String? ?? '',
      network: metadata['network'] as String? ?? '',
      type: metadata['type'] as String? ?? '',
      host: metadata['host'] as String? ?? '',
      rule: json['rule'] as String? ?? '',
      rulePayload: json['rulePayload'] as String? ?? '',
      chains: (json['chains'] as List?)?.join(' → ') ?? '',
      download: json['download'] as int? ?? 0,
      upload: json['upload'] as int? ?? 0,
      start: DateTime.tryParse(json['start'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class ProxyGroup {
  final String name;
  final String type;
  final List<String> all;
  final String? now;
  final int delay;

  const ProxyGroup({
    required this.name,
    required this.type,
    required this.all,
    this.now,
    this.delay = 0,
  });

  factory ProxyGroup.fromJson(Map<String, dynamic> json) => ProxyGroup(
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? '',
        all: (json['all'] as List?)?.cast<String>() ?? [],
        now: json['now'] as String?,
        delay: json['delay'] as int? ?? 0,
      );
}

class RuleInfo {
  final String type;
  final String payload;
  final String proxy;

  const RuleInfo({
    required this.type,
    required this.payload,
    required this.proxy,
  });

  factory RuleInfo.fromJson(Map<String, dynamic> json) => RuleInfo(
        type: json['type'] as String? ?? '',
        payload: json['payload'] as String? ?? '',
        proxy: json['proxy'] as String? ?? '',
      );
}

class ClashLogEntry {
  final String type;
  final String payload;

  const ClashLogEntry({required this.type, required this.payload});

  factory ClashLogEntry.fromJson(Map<String, dynamic> json) => ClashLogEntry(
        type: json['type'] as String? ?? 'info',
        payload: json['payload'] as String? ?? '',
      );
}
