import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrafficData {
  final int uploadTotal;
  final int downloadTotal;
  final int uploadSpeed; // bytes per second
  final int downloadSpeed; // bytes per second
  final List<SpeedPoint> speedHistory;

  const TrafficData({
    this.uploadTotal = 0,
    this.downloadTotal = 0,
    this.uploadSpeed = 0,
    this.downloadSpeed = 0,
    this.speedHistory = const [],
  });

  TrafficData copyWith({
    int? uploadTotal,
    int? downloadTotal,
    int? uploadSpeed,
    int? downloadSpeed,
    List<SpeedPoint>? speedHistory,
  }) {
    return TrafficData(
      uploadTotal: uploadTotal ?? this.uploadTotal,
      downloadTotal: downloadTotal ?? this.downloadTotal,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      speedHistory: speedHistory ?? this.speedHistory,
    );
  }
}

class SpeedPoint {
  final DateTime time;
  final int upload;
  final int download;

  const SpeedPoint({
    required this.time,
    required this.upload,
    required this.download,
  });
}

class TrafficMonitorNotifier extends StateNotifier<TrafficData> {
  Timer? _timer;
  final Dio _dio;
  final String _baseUrl;

  TrafficMonitorNotifier({String baseUrl = 'http://127.0.0.1:9090'})
      : _baseUrl = baseUrl,
        _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 2),
          receiveTimeout: const Duration(seconds: 2),
        )),
        super(const TrafficData());

  void startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _fetchTraffic());
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchTraffic() async {
    try {
      final response = await _dio.get('$_baseUrl/traffic');
      if (response.statusCode == 200) {
        final data = response.data;
        final up = (data['up'] as num?)?.toInt() ?? 0;
        final down = (data['down'] as num?)?.toInt() ?? 0;

        final newPoint = SpeedPoint(
          time: DateTime.now(),
          upload: up,
          download: down,
        );

        final history = [...state.speedHistory, newPoint];
        // Keep only last 60 seconds
        final cutoff = DateTime.now().subtract(const Duration(seconds: 60));
        final trimmed = history.where((p) => p.time.isAfter(cutoff)).toList();

        state = state.copyWith(
          uploadSpeed: up,
          downloadSpeed: down,
          uploadTotal: state.uploadTotal + up,
          downloadTotal: state.downloadTotal + down,
          speedHistory: trimmed,
        );
      }
    } catch (_) {
      // sing-box not running or API not available
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final trafficMonitorProvider =
    StateNotifierProvider<TrafficMonitorNotifier, TrafficData>(
  (ref) => TrafficMonitorNotifier(),
);

// Helper to format bytes
String formatBytes(int bytes, {int decimals = 1}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  var i = 0;
  double size = bytes.toDouble();
  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }
  return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
}

String formatSpeed(int bytesPerSecond) {
  return '${formatBytes(bytesPerSecond)}/s';
}
