import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

/// 开机自启动管理服务
class AutoStartService {
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// 初始化自启动配置
  Future<void> init() async {
    if (!isDesktop) return;
    launchAtStartup.setup(
      appName: 'FLSingBox',
      appPath: Platform.resolvedExecutable,
      args: ['--minimized'],
    );
  }

  /// 检查是否已设置开机自启
  Future<bool> isEnabled() async {
    if (!isDesktop) return false;
    return await launchAtStartup.isEnabled();
  }

  /// 启用开机自启
  Future<void> enable() async {
    if (!isDesktop) return;
    await launchAtStartup.enable();
  }

  /// 禁用开机自启
  Future<void> disable() async {
    if (!isDesktop) return;
    await launchAtStartup.disable();
  }

  /// 切换开机自启状态
  Future<bool> toggle() async {
    if (!isDesktop) return false;
    final enabled = await isEnabled();
    if (enabled) {
      await disable();
    } else {
      await enable();
    }
    return !enabled;
  }
}
