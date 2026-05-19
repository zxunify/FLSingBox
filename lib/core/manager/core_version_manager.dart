import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_path_resolver.dart';

/// 核心版本信息
class CoreVersionInfo {
  final String appVersion;
  final int buildNumber;
  final String coreVersion;
  final String? runningCoreVersion;
  final String releaseChannel;
  final String minCoreVersion;

  const CoreVersionInfo({
    required this.appVersion,
    required this.buildNumber,
    required this.coreVersion,
    this.runningCoreVersion,
    this.releaseChannel = 'stable',
    this.minCoreVersion = '1.10.0',
  });

  /// 是否需要更新核心
  bool get coreNeedsUpdate {
    if (runningCoreVersion == null) return false;
    return _compareVersions(runningCoreVersion!, coreVersion) < 0;
  }

  /// 运行中的核心是否满足最低版本要求
  bool get coreVersionSatisfied {
    if (runningCoreVersion == null) return true;
    return _compareVersions(runningCoreVersion!, minCoreVersion) >= 0;
  }

  /// 版本对比
  static int _compareVersions(String a, String b) {
    final aParts = a.split('.').map(int.tryParse).toList();
    final bParts = b.split('.').map(int.tryParse).toList();
    for (int i = 0; i < 3; i++) {
      final av = i < aParts.length ? (aParts[i] ?? 0) : 0;
      final bv = i < bParts.length ? (bParts[i] ?? 0) : 0;
      if (av != bv) return av.compareTo(bv);
    }
    return 0;
  }

  CoreVersionInfo copyWith({String? runningCoreVersion}) => CoreVersionInfo(
        appVersion: appVersion,
        buildNumber: buildNumber,
        coreVersion: coreVersion,
        runningCoreVersion: runningCoreVersion ?? this.runningCoreVersion,
        releaseChannel: releaseChannel,
        minCoreVersion: minCoreVersion,
      );
}

/// 核心版本管理器
/// 负责版本查询、对比、升级检查
class CoreVersionManager {
  final CorePathResolver _pathResolver;
  CoreVersionInfo? _cachedInfo;

  CoreVersionManager(this._pathResolver);

  /// 加载版本信息
  Future<CoreVersionInfo> loadVersionInfo() async {
    if (_cachedInfo != null) return _cachedInfo!;

    try {
      final jsonStr = await rootBundle.loadString('version.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      _cachedInfo = CoreVersionInfo(
        appVersion: json['app_version'] as String? ?? '0.0.0',
        buildNumber: json['build_number'] as int? ?? 0,
        coreVersion: json['core_version'] as String? ?? '0.0.0',
        releaseChannel: json['release_channel'] as String? ?? 'stable',
        minCoreVersion: json['min_core_version'] as String? ?? '1.10.0',
      );
    } catch (_) {
      _cachedInfo = const CoreVersionInfo(
        appVersion: '0.0.0',
        buildNumber: 0,
        coreVersion: '0.0.0',
      );
    }

    return _cachedInfo!;
  }

  /// 获取运行中的核心版本
  Future<CoreVersionInfo> getFullVersionInfo() async {
    final info = await loadVersionInfo();
    final runningVersion = await _pathResolver.getCoreVersion();
    return info.copyWith(runningCoreVersion: runningVersion);
  }

  /// 检查核心版本兼容性
  Future<({bool compatible, String message})> checkCompatibility() async {
    final info = await getFullVersionInfo();

    if (info.runningCoreVersion == null) {
      return (compatible: true, message: '无法获取核心版本');
    }

    if (!info.coreVersionSatisfied) {
      return (
        compatible: false,
        message:
            '核心版本 ${info.runningCoreVersion} 低于最低要求 ${info.minCoreVersion}',
      );
    }

    if (info.coreNeedsUpdate) {
      return (
        compatible: true,
        message: '核心版本 ${info.runningCoreVersion} 可更新到 ${info.coreVersion}',
      );
    }

    return (compatible: true, message: '核心版本符合要求');
  }

  /// 清除缓存
  void clearCache() => _cachedInfo = null;
}

/// 版本信息 Provider
final coreVersionInfoProvider = FutureProvider<CoreVersionInfo>((ref) async {
  final manager = CoreVersionManager(CorePathResolver.instance);
  return manager.getFullVersionInfo();
});
