import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppVersion {
  final String appVersion;
  final int buildNumber;
  final String coreVersion;
  final String releaseChannel;

  const AppVersion({
    this.appVersion = '0.1.0',
    this.buildNumber = 1,
    this.coreVersion = '1.12.0',
    this.releaseChannel = 'stable',
  });

  String get displayVersion => 'v$appVersion ($buildNumber)';
  String get coreDisplayVersion => 'v$coreVersion';
}

final appVersionProvider = FutureProvider<AppVersion>((ref) async {
  try {
    final jsonStr = await rootBundle.loadString('version.json');
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return AppVersion(
      appVersion: json['app_version'] as String? ?? '0.1.0',
      buildNumber: json['build_number'] as int? ?? 1,
      coreVersion: json['core_version'] as String? ?? '1.12.0',
      releaseChannel: json['release_channel'] as String? ?? 'stable',
    );
  } catch (_) {
    // Fallback to defaults
    return const AppVersion();
  }
});
