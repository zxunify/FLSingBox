import 'dart:async';
import 'dart:collection';

/// 日志级别
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// 单条日志
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final LogSource source;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    required this.source,
  });

  String get formattedTime =>
      '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')}.'
      '${timestamp.millisecond.toString().padLeft(3, '0')}';

  String get levelTag {
    switch (level) {
      case LogLevel.debug:
        return 'DBG';
      case LogLevel.info:
        return 'INF';
      case LogLevel.warning:
        return 'WRN';
      case LogLevel.error:
        return 'ERR';
      case LogLevel.fatal:
        return 'FTL';
    }
  }

  @override
  String toString() => '[$formattedTime] [$levelTag] [$source] $message';
}

/// 日志来源
enum LogSource {
  core('核心'),
  system('系统'),
  platform('平台');

  final String label;
  const LogSource(this.label);
}

/// 核心日志管理器
/// 负责日志收集、缓存、实时推送、导出
class CoreLogManager {
  /// 最大缓存日志条数
  static const int maxLogEntries = 5000;

  /// 日志环形缓冲区
  final _logs = Queue<LogEntry>();

  /// 实时日志流
  final _logStreamController = StreamController<LogEntry>.broadcast();

  /// 核心原始输出流（未解析）
  final _rawStreamController = StreamController<String>.broadcast();

  /// 实时日志流
  Stream<LogEntry> get logStream => _logStreamController.stream;

  /// 核心原始输出流
  Stream<String> get rawStream => _rawStreamController.stream;

  /// 当前所有缓存的日志
  List<LogEntry> get logs => _logs.toList();

  /// 日志条数
  int get logCount => _logs.length;

  /// 添加核心日志（解析 sing-box 输出格式）
  void addCoreLog(String rawLine, {bool isError = false}) {
    _rawStreamController.add(rawLine);

    final entry = _parseCoreLog(rawLine, isError: isError);
    _addEntry(entry);
  }

  /// 添加系统日志
  void addSystemLog(LogLevel level, String message) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      source: LogSource.system,
    );
    _addEntry(entry);
  }

  /// 添加平台日志
  void addPlatformLog(LogLevel level, String message) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      source: LogSource.platform,
    );
    _addEntry(entry);
  }

  /// 按级别过滤日志
  List<LogEntry> filterByLevel(LogLevel minLevel) {
    return _logs.where((e) => e.level.index >= minLevel.index).toList();
  }

  /// 按来源过滤
  List<LogEntry> filterBySource(LogSource source) {
    return _logs.where((e) => e.source == source).toList();
  }

  /// 搜索日志
  List<LogEntry> search(String keyword) {
    final lower = keyword.toLowerCase();
    return _logs
        .where((e) => e.message.toLowerCase().contains(lower))
        .toList();
  }

  /// 导出所有日志为文本
  String exportAsText() {
    final buffer = StringBuffer();
    buffer.writeln('=== FLSingBox 日志导出 ===');
    buffer.writeln('导出时间: ${DateTime.now()}');
    buffer.writeln('日志条数: ${_logs.length}');
    buffer.writeln('========================');
    buffer.writeln();
    for (final entry in _logs) {
      buffer.writeln(entry.toString());
    }
    return buffer.toString();
  }

  /// 清除所有日志
  void clear() {
    _logs.clear();
  }

  /// 获取最近 N 条日志
  List<LogEntry> getRecent(int count) {
    if (_logs.length <= count) return _logs.toList();
    return _logs.toList().sublist(_logs.length - count);
  }

  /// 获取最后一条错误日志
  LogEntry? get lastError {
    try {
      return _logs.lastWhere(
        (e) => e.level == LogLevel.error || e.level == LogLevel.fatal,
      );
    } catch (_) {
      return null;
    }
  }

  void _addEntry(LogEntry entry) {
    _logs.add(entry);
    while (_logs.length > maxLogEntries) {
      _logs.removeFirst();
    }
    _logStreamController.add(entry);
  }

  /// 解析 sing-box 日志格式
  /// sing-box 日志格式: timestamp level message
  /// 例如: INFO[0000] sing-box started
  LogEntry _parseCoreLog(String line, {bool isError = false}) {
    LogLevel level = isError ? LogLevel.error : LogLevel.info;

    // 尝试解析 sing-box JSON 日志格式
    // {"level":"info","msg":"...","time":"..."}
    if (line.startsWith('{')) {
      try {
        // 简单提取 level
        final levelMatch = RegExp(r'"level"\s*:\s*"(\w+)"').firstMatch(line);
        if (levelMatch != null) {
          level = _parseLevel(levelMatch.group(1)!);
        }
        final msgMatch = RegExp(r'"msg"\s*:\s*"([^"]*)"').firstMatch(line);
        final message = msgMatch?.group(1) ?? line;
        return LogEntry(
          timestamp: DateTime.now(),
          level: level,
          message: message,
          source: LogSource.core,
        );
      } catch (_) {}
    }

    // 尝试解析传统格式
    // INFO[0000] message
    final match = RegExp(r'^(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\[?').firstMatch(line);
    if (match != null) {
      level = _parseLevel(match.group(1)!);
      final msgStart = line.indexOf('] ');
      final message = msgStart >= 0 ? line.substring(msgStart + 2) : line;
      return LogEntry(
        timestamp: DateTime.now(),
        level: level,
        message: message,
        source: LogSource.core,
      );
    }

    return LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: line,
      source: LogSource.core,
    );
  }

  LogLevel _parseLevel(String levelStr) {
    switch (levelStr.toLowerCase()) {
      case 'trace':
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warn':
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'fatal':
      case 'panic':
        return LogLevel.fatal;
      default:
        return LogLevel.info;
    }
  }

  void dispose() {
    _logStreamController.close();
    _rawStreamController.close();
  }
}
