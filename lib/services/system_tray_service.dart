import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

/// 桌面端系统托盘管理
class SystemTrayService with TrayListener {
  bool _initialized = false;
  VoidCallback? onShowWindow;
  VoidCallback? onToggleProxy;
  VoidCallback? onQuit;

  bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  Future<void> init() async {
    if (!isDesktop || _initialized) return;
    _initialized = true;

    await trayManager.setIcon(_getTrayIconPath());
    await trayManager.setToolTip('FLSingBox - 已停止');

    final menu = Menu(items: [
      MenuItem(key: 'show', label: '显示主窗口'),
      MenuItem.separator(),
      MenuItem(key: 'toggle', label: '启动/停止代理'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: '退出'),
    ]);
    await trayManager.setContextMenu(menu);
    trayManager.addListener(this);
  }

  Future<void> dispose() async {
    if (!isDesktop) return;
    trayManager.removeListener(this);
    await trayManager.destroy();
  }

  Future<void> updateStatus(bool isRunning) async {
    if (!isDesktop) return;
    await trayManager.setToolTip(
      isRunning ? 'FLSingBox - 运行中' : 'FLSingBox - 已停止',
    );
  }

  String _getTrayIconPath() {
    if (Platform.isWindows) {
      return 'assets/icons/tray_icon.ico';
    }
    return 'assets/icons/tray_icon.png';
  }

  @override
  void onTrayIconMouseDown() {
    onShowWindow?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        onShowWindow?.call();
      case 'toggle':
        onToggleProxy?.call();
      case 'quit':
        onQuit?.call();
    }
  }
}

/// 窗口管理服务
class WindowService with WindowListener {
  bool _initialized = false;
  bool _preventClose = true;

  bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  Future<void> init({bool preventClose = true}) async {
    if (!isDesktop || _initialized) return;
    _initialized = true;
    _preventClose = preventClose;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1100, 700),
      minimumSize: Size(800, 500),
      center: true,
      title: 'FLSingBox',
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    if (_preventClose) {
      await windowManager.setPreventClose(true);
      windowManager.addListener(this);
    }
  }

  Future<void> show() async {
    if (!isDesktop) return;
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> hide() async {
    if (!isDesktop) return;
    await windowManager.hide();
  }

  @override
  void onWindowClose() async {
    if (_preventClose) {
      await windowManager.hide();
    }
  }
}
