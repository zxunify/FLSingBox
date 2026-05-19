import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 核心路径解析器
/// 统一管理各平台 sing-box 核心二进制文件的路径定位
class CorePathResolver {
  CorePathResolver._();
  static final instance = CorePathResolver._();

  String? _customPath;
  String? _resolvedPath;

  /// 设置用户自定义核心路径
  void setCustomPath(String? path) {
    _customPath = path;
    _resolvedPath = null;
  }

  /// 获取核心二进制文件名
  String get binaryName {
    if (Platform.isWindows) return 'sing-box.exe';
    return 'sing-box';
  }

  /// 解析核心路径（带缓存）
  Future<String?> resolve() async {
    if (_resolvedPath != null && File(_resolvedPath!).existsSync()) {
      return _resolvedPath;
    }
    _resolvedPath = await _doResolve();
    return _resolvedPath;
  }

  /// 强制重新解析
  Future<String?> forceResolve() async {
    _resolvedPath = null;
    return resolve();
  }

  /// 检查核心是否存在
  Future<bool> exists() async {
    final path = await resolve();
    return path != null && File(path).existsSync();
  }

  /// 获取核心所在目录
  Future<String?> getCoreDirectory() async {
    final path = await resolve();
    if (path == null) return null;
    return p.dirname(path);
  }

  /// 获取运行时工作目录（存放配置、缓存等）
  Future<String> getWorkingDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final workDir = Directory(p.join(appDir.path, 'singbox'));
    if (!workDir.existsSync()) {
      await workDir.create(recursive: true);
    }
    return workDir.path;
  }

  /// 获取配置文件目录
  Future<String> getConfigDirectory() async {
    final workDir = await getWorkingDirectory();
    final configDir = Directory(p.join(workDir, 'config'));
    if (!configDir.existsSync()) {
      await configDir.create(recursive: true);
    }
    return configDir.path;
  }

  /// 获取日志文件目录
  Future<String> getLogDirectory() async {
    final workDir = await getWorkingDirectory();
    final logDir = Directory(p.join(workDir, 'logs'));
    if (!logDir.existsSync()) {
      await logDir.create(recursive: true);
    }
    return logDir.path;
  }

  Future<String?> _doResolve() async {
    // 1. 用户自定义路径优先
    if (_customPath != null && _customPath!.isNotEmpty) {
      if (File(_customPath!).existsSync()) return _customPath;
    }

    // 2. 应用内置路径（打包时注入的核心）
    final bundledPath = await _resolveBundledPath();
    if (bundledPath != null) return bundledPath;

    // 3. 应用数据目录（运行时释放的核心）
    final releasedPath = await _resolveReleasedPath();
    if (releasedPath != null) return releasedPath;

    // 4. 系统 PATH 搜索
    final systemPath = await _resolveSystemPath();
    if (systemPath != null) return systemPath;

    return null;
  }

  /// 解析打包在应用内的核心路径
  Future<String?> _resolveBundledPath() async {
    if (Platform.isWindows) {
      // Windows: exe 同级目录下的 data/core/sing-box.exe
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final paths = [
        p.join(exeDir, 'data', 'core', binaryName),
        p.join(exeDir, binaryName),
      ];
      for (final path in paths) {
        if (File(path).existsSync()) return path;
      }
    } else if (Platform.isMacOS) {
      // macOS: .app/Contents/Resources/core/sing-box
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final resourcesDir = p.join(p.dirname(exeDir), 'Resources');
      final paths = [
        p.join(resourcesDir, 'core', binaryName),
        p.join(resourcesDir, binaryName),
        p.join(exeDir, binaryName),
      ];
      for (final path in paths) {
        if (File(path).existsSync()) return path;
      }
    } else if (Platform.isLinux) {
      // Linux: AppImage/AppDir 或安装目录
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final paths = [
        p.join(exeDir, 'data', 'core', binaryName),
        p.join(exeDir, binaryName),
        // AppImage 解包路径
        p.join(exeDir, '..', 'usr', 'bin', binaryName),
        p.join(exeDir, '..', 'lib', binaryName),
      ];
      for (final path in paths) {
        if (File(path).existsSync()) return path;
      }
    }
    return null;
  }

  /// 解析释放到应用数据目录的核心
  Future<String?> _resolveReleasedPath() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final paths = [
        p.join(appDir.path, 'core', binaryName),
        p.join(appDir.path, 'singbox', binaryName),
      ];
      for (final path in paths) {
        if (File(path).existsSync()) return path;
      }
    } catch (_) {}
    return null;
  }

  /// 在系统 PATH 中搜索
  Future<String?> _resolveSystemPath() async {
    // 常见路径
    final knownPaths = <String>[];
    if (Platform.isWindows) {
      knownPaths.addAll([
        r'C:\Program Files\sing-box\sing-box.exe',
        r'C:\Program Files (x86)\sing-box\sing-box.exe',
      ]);
    } else {
      knownPaths.addAll([
        '/usr/local/bin/sing-box',
        '/usr/bin/sing-box',
        '/opt/homebrew/bin/sing-box',
        p.join(
          Platform.environment['HOME'] ?? '/root',
          '.local',
          'bin',
          'sing-box',
        ),
      ]);
    }

    for (final path in knownPaths) {
      if (File(path).existsSync()) return path;
    }

    // 使用 which/where 命令搜索
    try {
      final result = await Process.run(
        Platform.isWindows ? 'where' : 'which',
        ['sing-box'],
      );
      if (result.exitCode == 0) {
        final found = (result.stdout as String).trim().split('\n').first;
        if (found.isNotEmpty && File(found).existsSync()) return found;
      }
    } catch (_) {}

    return null;
  }

  /// 检查核心文件是否有执行权限（Unix）
  Future<bool> hasExecutePermission() async {
    final path = await resolve();
    if (path == null) return false;
    if (Platform.isWindows) return true; // Windows 不需要执行权限

    try {
      final stat = await File(path).stat();
      // 检查 owner execute bit
      return (stat.mode & 0x40) != 0;
    } catch (_) {
      return false;
    }
  }

  /// 设置执行权限（Unix）
  Future<bool> setExecutePermission() async {
    final path = await resolve();
    if (path == null) return false;
    if (Platform.isWindows) return true;

    try {
      final result = await Process.run('chmod', ['+x', path]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// 获取核心版本
  Future<String?> getCoreVersion() async {
    final path = await resolve();
    if (path == null) return null;

    try {
      final result = await Process.run(path, ['version']);
      if (result.exitCode == 0) {
        final output = (result.stdout as String).trim();
        // sing-box version 1.x.x
        final match = RegExp(r'sing-box version (\S+)').firstMatch(output);
        return match?.group(1);
      }
    } catch (_) {}
    return null;
  }

  @override
  String toString() =>
      'CorePathResolver(resolved=$_resolvedPath, custom=$_customPath)';
}
