import 'dart:io';
import 'package:flutter/foundation.dart';
import '../manager/core_path_resolver.dart';

/// 权限状态
enum PermissionStatus {
  granted('已授权'),
  denied('未授权'),
  unknown('未知'),
  notRequired('无需授权');

  final String label;
  const PermissionStatus(this.label);
}

/// 权限检查结果
class PermissionCheckResult {
  final PermissionStatus status;
  final String message;
  final PermissionAction? requiredAction;

  const PermissionCheckResult({
    required this.status,
    required this.message,
    this.requiredAction,
  });

  bool get isGranted =>
      status == PermissionStatus.granted ||
      status == PermissionStatus.notRequired;
}

/// 需要的权限操作
enum PermissionAction {
  setExecutable('设置执行权限'),
  elevatePrivilege('提升权限'),
  installHelper('安装辅助服务'),
  requestVpn('请求 VPN 权限'),
  requestNotification('请求通知权限');

  final String label;
  const PermissionAction(this.label);
}

/// 平台权限管理器
/// 跨平台统一接口，处理各平台权限差异
abstract class PlatformPermission {
  /// 获取当前平台实例
  static PlatformPermission get instance {
    if (kIsWeb) return _WebPermission();
    if (Platform.isWindows) return WindowsPermission();
    if (Platform.isMacOS) return MacOSPermission();
    if (Platform.isLinux) return LinuxPermission();
    if (Platform.isAndroid) return AndroidPermission();
    return _WebPermission();
  }

  /// 检查核心运行所需的所有权限
  Future<PermissionCheckResult> checkCorePermissions(CorePathResolver resolver);

  /// 尝试修复权限问题
  Future<bool> fixPermissions(CorePathResolver resolver);

  /// 检查 TUN 权限
  Future<PermissionCheckResult> checkTunPermission();

  /// 检查系统代理权限
  Future<PermissionCheckResult> checkSystemProxyPermission();

  /// 获取平台相关提示信息
  String get platformHint;
}

/// Windows 权限管理
class WindowsPermission extends PlatformPermission {
  @override
  Future<PermissionCheckResult> checkCorePermissions(
    CorePathResolver resolver,
  ) async {
    final exists = await resolver.exists();
    if (!exists) {
      return const PermissionCheckResult(
        status: PermissionStatus.denied,
        message: '核心文件不存在',
        requiredAction: null,
      );
    }
    // Windows 上核心文件存在即可运行
    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '核心文件可执行',
    );
  }

  @override
  Future<bool> fixPermissions(CorePathResolver resolver) async {
    // Windows 无需特殊权限修复
    return true;
  }

  @override
  Future<PermissionCheckResult> checkTunPermission() async {
    // Windows TUN 需要管理员权限
    if (await _isElevated()) {
      return const PermissionCheckResult(
        status: PermissionStatus.granted,
        message: '当前以管理员权限运行',
      );
    }
    return const PermissionCheckResult(
      status: PermissionStatus.denied,
      message: 'TUN 模式需要管理员权限',
      requiredAction: PermissionAction.elevatePrivilege,
    );
  }

  @override
  Future<PermissionCheckResult> checkSystemProxyPermission() async {
    // Windows 设置系统代理不需要管理员权限
    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '系统代理设置无需额外权限',
    );
  }

  @override
  String get platformHint => 'Windows: TUN 模式需要以管理员身份运行';

  Future<bool> _isElevated() async {
    try {
      final result = await Process.run('net', ['session']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// 请求管理员权限重启
  Future<bool> requestElevation(String exePath) async {
    try {
      // 使用 PowerShell 提权
      final result = await Process.run('powershell', [
        '-Command',
        'Start-Process "$exePath" -Verb RunAs',
      ]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// 检查/安装 Windows helper service
  Future<bool> isHelperInstalled() async {
    try {
      final result = await Process.run('sc', ['query', 'FLSingBoxHelper']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}

/// macOS 权限管理
class MacOSPermission extends PlatformPermission {
  @override
  Future<PermissionCheckResult> checkCorePermissions(
    CorePathResolver resolver,
  ) async {
    final exists = await resolver.exists();
    if (!exists) {
      return const PermissionCheckResult(
        status: PermissionStatus.denied,
        message: '核心文件不存在',
      );
    }

    final hasPermission = await resolver.hasExecutePermission();
    if (!hasPermission) {
      return const PermissionCheckResult(
        status: PermissionStatus.denied,
        message: '核心文件无执行权限',
        requiredAction: PermissionAction.setExecutable,
      );
    }

    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '核心文件权限正常',
    );
  }

  @override
  Future<bool> fixPermissions(CorePathResolver resolver) async {
    return resolver.setExecutePermission();
  }

  @override
  Future<PermissionCheckResult> checkTunPermission() async {
    // macOS TUN 需要 root 或特殊 entitlement
    final uid = int.tryParse(
      Platform.environment['EUID'] ?? Platform.environment['UID'] ?? '',
    );
    if (uid == 0) {
      return const PermissionCheckResult(
        status: PermissionStatus.granted,
        message: '当前以 root 权限运行',
      );
    }
    return const PermissionCheckResult(
      status: PermissionStatus.denied,
      message: 'TUN 模式需要 root 权限或 Network Extension',
      requiredAction: PermissionAction.elevatePrivilege,
    );
  }

  @override
  Future<PermissionCheckResult> checkSystemProxyPermission() async {
    // macOS networksetup 需要管理员权限
    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '系统代理设置可能需要输入密码授权',
    );
  }

  @override
  String get platformHint => 'macOS: TUN 模式需要授权，首次使用可能需要输入密码';

  /// 使用 osascript 请求权限
  Future<bool> requestSudoPermission(String command) async {
    try {
      final result = await Process.run('osascript', [
        '-e',
        'do shell script "$command" with administrator privileges',
      ]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}

/// Linux 权限管理
class LinuxPermission extends PlatformPermission {
  @override
  Future<PermissionCheckResult> checkCorePermissions(
    CorePathResolver resolver,
  ) async {
    final exists = await resolver.exists();
    if (!exists) {
      return const PermissionCheckResult(
        status: PermissionStatus.denied,
        message: '核心文件不存在',
      );
    }

    final hasPermission = await resolver.hasExecutePermission();
    if (!hasPermission) {
      return const PermissionCheckResult(
        status: PermissionStatus.denied,
        message: '核心文件无执行权限',
        requiredAction: PermissionAction.setExecutable,
      );
    }

    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '核心文件权限正常',
    );
  }

  @override
  Future<bool> fixPermissions(CorePathResolver resolver) async {
    final set = await resolver.setExecutePermission();
    if (!set) return false;

    // 尝试设置 cap_net_admin (TUN 所需)
    final path = await resolver.resolve();
    if (path != null) {
      await _setNetCapability(path);
    }
    return true;
  }

  @override
  Future<PermissionCheckResult> checkTunPermission() async {
    final uid = int.tryParse(Platform.environment['EUID'] ?? '');
    if (uid == 0) {
      return const PermissionCheckResult(
        status: PermissionStatus.granted,
        message: '当前以 root 权限运行',
      );
    }

    // 检查是否有 NET_ADMIN capability
    return const PermissionCheckResult(
      status: PermissionStatus.denied,
      message: 'TUN 模式需要 root 权限或 CAP_NET_ADMIN',
      requiredAction: PermissionAction.elevatePrivilege,
    );
  }

  @override
  Future<PermissionCheckResult> checkSystemProxyPermission() async {
    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: '系统代理通过环境变量设置，无需额外权限',
    );
  }

  @override
  String get platformHint =>
      'Linux: TUN 模式需要 root 权限，或使用 sudo setcap cap_net_admin+ep sing-box';

  Future<bool> _setNetCapability(String binaryPath) async {
    try {
      final result = await Process.run('sudo', [
        'setcap',
        'cap_net_bind_service,cap_net_admin+ep',
        binaryPath,
      ]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// 使用 pkexec 请求权限
  Future<bool> requestElevation(String command, List<String> args) async {
    try {
      final result = await Process.run('pkexec', [command, ...args]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}

/// Android 权限管理
class AndroidPermission extends PlatformPermission {
  @override
  Future<PermissionCheckResult> checkCorePermissions(
    CorePathResolver resolver,
  ) async {
    // Android 核心通过原生层管理
    return const PermissionCheckResult(
      status: PermissionStatus.granted,
      message: 'Android 核心由原生层管理',
    );
  }

  @override
  Future<bool> fixPermissions(CorePathResolver resolver) async {
    return true;
  }

  @override
  Future<PermissionCheckResult> checkTunPermission() async {
    // Android VPN 权限通过系统 VPN 确认对话框
    return const PermissionCheckResult(
      status: PermissionStatus.unknown,
      message: 'VPN 权限需要用户确认',
      requiredAction: PermissionAction.requestVpn,
    );
  }

  @override
  Future<PermissionCheckResult> checkSystemProxyPermission() async {
    return const PermissionCheckResult(
      status: PermissionStatus.notRequired,
      message: 'Android 通过 VPN 服务接管流量',
    );
  }

  @override
  String get platformHint => 'Android: 首次使用需要授权 VPN 连接';
}

/// Web 平台（不支持核心管理）
class _WebPermission extends PlatformPermission {
  @override
  Future<PermissionCheckResult> checkCorePermissions(
    CorePathResolver resolver,
  ) async =>
      const PermissionCheckResult(
        status: PermissionStatus.notRequired,
        message: 'Web 平台不支持本地核心',
      );

  @override
  Future<bool> fixPermissions(CorePathResolver resolver) async => false;

  @override
  Future<PermissionCheckResult> checkTunPermission() async =>
      const PermissionCheckResult(
        status: PermissionStatus.notRequired,
        message: 'Web 平台不支持 TUN',
      );

  @override
  Future<PermissionCheckResult> checkSystemProxyPermission() async =>
      const PermissionCheckResult(
        status: PermissionStatus.notRequired,
        message: 'Web 平台不支持系统代理',
      );

  @override
  String get platformHint => 'Web 平台仅供预览，不支持核心管理功能';
}
