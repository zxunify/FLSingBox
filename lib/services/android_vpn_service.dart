import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Android VPN 平台通道
class AndroidVpnService {
  static const _channel = MethodChannel('com.flsingbox/vpn');

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// 启动 VPN 服务
  Future<bool> startVpn(String configPath) async {
    if (!isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('startVpn', {
        'configPath': configPath,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to start VPN: ${e.message}');
      return false;
    }
  }

  /// 停止 VPN 服务
  Future<bool> stopVpn() async {
    if (!isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('stopVpn');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to stop VPN: ${e.message}');
      return false;
    }
  }

  /// 检查 VPN 运行状态
  Future<bool> isVpnRunning() async {
    if (!isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('isVpnRunning');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
