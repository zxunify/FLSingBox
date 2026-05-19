import 'dart:io';
import 'package:flutter/foundation.dart';

/// 系统代理设置服务
/// 支持 Windows/macOS/Linux 三平台设置 HTTP 系统代理
class SystemProxyService {
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// 设置系统 HTTP 代理
  Future<bool> setProxy({
    required String host,
    required int httpPort,
    required int socksPort,
  }) async {
    if (!isDesktop) return false;

    try {
      if (Platform.isWindows) {
        return _setWindowsProxy(host, httpPort);
      } else if (Platform.isMacOS) {
        return _setMacProxy(host, httpPort, socksPort);
      } else if (Platform.isLinux) {
        return _setLinuxProxy(host, httpPort, socksPort);
      }
      return false;
    } catch (e) {
      debugPrint('Failed to set system proxy: $e');
      return false;
    }
  }

  /// 清除系统代理
  Future<bool> clearProxy() async {
    if (!isDesktop) return false;

    try {
      if (Platform.isWindows) {
        return _clearWindowsProxy();
      } else if (Platform.isMacOS) {
        return _clearMacProxy();
      } else if (Platform.isLinux) {
        return _clearLinuxProxy();
      }
      return false;
    } catch (e) {
      debugPrint('Failed to clear system proxy: $e');
      return false;
    }
  }

  // ============ Windows ============
  Future<bool> _setWindowsProxy(String host, int port) async {
    final result = await Process.run('reg', [
      'add',
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
      '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '1', '/f',
    ]);
    if (result.exitCode != 0) return false;

    final result2 = await Process.run('reg', [
      'add',
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
      '/v', 'ProxyServer', '/t', 'REG_SZ', '/d', '$host:$port', '/f',
    ]);
    if (result2.exitCode != 0) return false;

    // 设置绕过本地地址
    await Process.run('reg', [
      'add',
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
      '/v', 'ProxyOverride', '/t', 'REG_SZ',
      '/d', 'localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*;<local>',
      '/f',
    ]);

    return true;
  }

  Future<bool> _clearWindowsProxy() async {
    final result = await Process.run('reg', [
      'add',
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
      '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '0', '/f',
    ]);
    return result.exitCode == 0;
  }

  // ============ macOS ============
  Future<bool> _setMacProxy(String host, int httpPort, int socksPort) async {
    // 获取网络服务名称
    final services = await _getMacNetworkServices();

    for (final service in services) {
      await Process.run('networksetup', ['-setwebproxy', service, host, '$httpPort']);
      await Process.run('networksetup', ['-setsecurewebproxy', service, host, '$httpPort']);
      await Process.run('networksetup', ['-setsocksfirewallproxy', service, host, '$socksPort']);
      await Process.run('networksetup', ['-setwebproxystate', service, 'on']);
      await Process.run('networksetup', ['-setsecurewebproxystate', service, 'on']);
      await Process.run('networksetup', ['-setsocksfirewallproxystate', service, 'on']);
    }
    return true;
  }

  Future<bool> _clearMacProxy() async {
    final services = await _getMacNetworkServices();
    for (final service in services) {
      await Process.run('networksetup', ['-setwebproxystate', service, 'off']);
      await Process.run('networksetup', ['-setsecurewebproxystate', service, 'off']);
      await Process.run('networksetup', ['-setsocksfirewallproxystate', service, 'off']);
    }
    return true;
  }

  Future<List<String>> _getMacNetworkServices() async {
    final result = await Process.run('networksetup', ['-listallnetworkservices']);
    if (result.exitCode != 0) return [];
    return (result.stdout as String)
        .split('\n')
        .skip(1) // Skip header line
        .where((s) => s.trim().isNotEmpty && !s.startsWith('*'))
        .toList();
  }

  // ============ Linux ============
  Future<bool> _setLinuxProxy(String host, int httpPort, int socksPort) async {
    // GNOME desktop
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy', 'mode', "'manual'"]);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.http', 'host', "'$host'"]);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.http', 'port', '$httpPort']);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.https', 'host', "'$host'"]);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.https', 'port', '$httpPort']);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.socks', 'host', "'$host'"]);
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy.socks', 'port', '$socksPort']);
    return true;
  }

  Future<bool> _clearLinuxProxy() async {
    await Process.run('gsettings', ['set', 'org.gnome.system.proxy', 'mode', "'none'"]);
    return true;
  }
}
