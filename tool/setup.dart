/// flsingbox 统一构建脚本
/// 
/// 用法:
///   dart tool/setup.dart <platform> [options]
///
/// 平台:
///   android    构建 Android APK/AAB
///   windows    构建 Windows 可执行文件
///   macos      构建 macOS 应用
///   linux      构建 Linux 应用
///   all        构建所有平台
///   core       仅下载核心
///   clean      清理构建产物
///
/// 选项:
///   --arch <arch>       指定架构 (x64, arm64, arm)
///   --release           Release 模式 (默认)
///   --debug             Debug 模式
///   --no-core           跳过核心下载
///   --core-version <v>  指定 sing-box 版本
///   --output <dir>      输出目录 (默认 dist/)

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

// ===== Version Config =====
class VersionConfig {
  final String appVersion;
  final int buildNumber;
  final String coreVersion;
  final String releaseChannel;
  final Map<String, dynamic> platforms;
  final String coreDownloadUrlTemplate;
  final Map<String, String> coreBinaryName;

  VersionConfig({
    required this.appVersion,
    required this.buildNumber,
    required this.coreVersion,
    required this.releaseChannel,
    required this.platforms,
    required this.coreDownloadUrlTemplate,
    required this.coreBinaryName,
  });

  factory VersionConfig.load(String projectRoot) {
    final file = File(path.join(projectRoot, 'version.json'));
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return VersionConfig(
      appVersion: json['app_version'] as String,
      buildNumber: json['build_number'] as int,
      coreVersion: json['core_version'] as String,
      releaseChannel: json['release_channel'] as String,
      platforms: json['platforms'] as Map<String, dynamic>,
      coreDownloadUrlTemplate: json['core_download_url_template'] as String,
      coreBinaryName: Map<String, String>.from(json['core_binary_name'] as Map),
    );
  }

  String get versionTag => 'v$appVersion';
  String get fullVersion => '$appVersion+$buildNumber';
}

// ===== Core Downloader =====
class CoreDownloader {
  final VersionConfig config;
  final String projectRoot;

  CoreDownloader(this.config, this.projectRoot);

  String _getCoreUrl(String platform, String arch) {
    final ext = platform == 'windows' ? '.zip' : '.tar.gz';
    // sing-box release naming convention
    final platformName = switch (platform) {
      'windows' => 'windows',
      'macos' => 'darwin',
      'linux' => 'linux',
      'android' => 'android',
      _ => platform,
    };
    final archName = switch (arch) {
      'x64' => 'amd64',
      'x86_64' => 'amd64',
      'arm64' => 'arm64',
      'arm64-v8a' => 'arm64',
      'armeabi-v7a' => 'armv7',
      _ => arch,
    };
    return config.coreDownloadUrlTemplate
        .replaceAll('{version}', config.coreVersion)
        .replaceAll('{platform}', platformName)
        .replaceAll('{arch}', archName)
        .replaceAll('{ext}', ext);
  }

  String _getCoreDir() => path.join(projectRoot, '.cache', 'core');

  Future<String> download(String platform, String arch) async {
    final url = _getCoreUrl(platform, arch);
    final cacheDir = _getCoreDir();
    final archiveFileName = path.basename(Uri.parse(url).path);
    final archivePath = path.join(cacheDir, archiveFileName);
    final binaryName = config.coreBinaryName[platform] ?? 'sing-box';

    // Check cache
    final outputPath = path.join(cacheDir, '${platform}_$arch', binaryName);
    if (File(outputPath).existsSync()) {
      print('  ✓ Core cached: $outputPath');
      return outputPath;
    }

    // Ensure cache dir exists
    Directory(path.join(cacheDir, '${platform}_$arch')).createSync(recursive: true);

    // Download
    print('  ↓ Downloading: $url');
    final result = await Process.run('curl', [
      '-L', '-o', archivePath,
      '--fail', '--progress-bar',
      url,
    ]);
    if (result.exitCode != 0) {
      throw Exception('Failed to download core: ${result.stderr}');
    }

    // Extract
    print('  ↗ Extracting...');
    if (platform == 'windows') {
      await Process.run('unzip', ['-o', archivePath, '-d', path.join(cacheDir, '${platform}_$arch')]);
    } else {
      await Process.run('tar', [
        'xzf', archivePath,
        '-C', path.join(cacheDir, '${platform}_$arch'),
        '--strip-components=1',
      ]);
    }

    // Verify extracted binary
    if (!File(outputPath).existsSync()) {
      // Try to find it
      final dir = Directory(path.join(cacheDir, '${platform}_$arch'));
      final files = dir.listSync(recursive: true);
      for (final f in files) {
        if (path.basename(f.path) == binaryName) {
          File(f.path).copySync(outputPath);
          break;
        }
      }
    }

    if (!File(outputPath).existsSync()) {
      throw Exception('Core binary not found after extraction');
    }

    // Set executable permission
    if (platform != 'windows') {
      await Process.run('chmod', ['+x', outputPath]);
    }

    print('  ✓ Core ready: $outputPath');
    return outputPath;
  }
}

// ===== Platform Builder =====
abstract class PlatformBuilder {
  final VersionConfig config;
  final String projectRoot;
  final String outputDir;
  final CoreDownloader coreDownloader;
  final bool isRelease;

  PlatformBuilder({
    required this.config,
    required this.projectRoot,
    required this.outputDir,
    required this.coreDownloader,
    this.isRelease = true,
  });

  String get platformName;

  Future<void> build() async {
    print('\n═══ Building $platformName ═══');
    await prepareCores();
    await flutterBuild();
    await package();
    print('  ✓ $platformName build complete');
  }

  Future<void> prepareCores();
  Future<void> flutterBuild();
  Future<void> package();

  Future<int> runCmd(String executable, List<String> args, {String? workDir}) async {
    print('  > $executable ${args.join(' ')}');
    final process = await Process.start(
      executable,
      args,
      workingDirectory: workDir ?? projectRoot,
      mode: ProcessStartMode.inheritStdio,
    );
    return process.exitCode;
  }
}

// ===== Android Builder =====
class AndroidBuilder extends PlatformBuilder {
  AndroidBuilder({
    required super.config,
    required super.projectRoot,
    required super.outputDir,
    required super.coreDownloader,
    super.isRelease,
  });

  @override
  String get platformName => 'Android';

  @override
  Future<void> prepareCores() async {
    final archs = (config.platforms['android']?['architectures'] as List?)
            ?.cast<String>() ??
        ['arm64-v8a'];
    for (final arch in archs) {
      final corePath = await coreDownloader.download('android', arch);
      final jniDir = path.join(projectRoot, 'android', 'app', 'src', 'main', 'jniLibs', arch);
      Directory(jniDir).createSync(recursive: true);
      File(corePath).copySync(path.join(jniDir, 'libsingbox.so'));
    }
    // Also copy to assets for process-based approach
    final assetsDir = path.join(projectRoot, 'assets', 'singbox');
    Directory(assetsDir).createSync(recursive: true);
    final corePath = await coreDownloader.download('android', 'arm64-v8a');
    File(corePath).copySync(path.join(assetsDir, 'sing-box'));
  }

  @override
  Future<void> flutterBuild() async {
    final mode = isRelease ? '--release' : '--debug';
    // Build APK
    var code = await runCmd('flutter', ['build', 'apk', mode, '--split-per-abi']);
    if (code != 0) throw Exception('Flutter APK build failed');

    // Build AAB
    code = await runCmd('flutter', ['build', 'appbundle', mode]);
    if (code != 0) throw Exception('Flutter AAB build failed');
  }

  @override
  Future<void> package() async {
    final distDir = path.join(outputDir, 'android');
    Directory(distDir).createSync(recursive: true);

    final version = config.appVersion;
    // Copy APK
    final apkDir = path.join(projectRoot, 'build', 'app', 'outputs', 'flutter-apk');
    final apks = Directory(apkDir).listSync().where((f) => f.path.endsWith('.apk'));
    for (final apk in apks) {
      final name = path.basename(apk.path).replaceAll('app-', 'flsingbox-android-');
      final dest = path.join(distDir, name.replaceAll('.apk', '-v$version.apk'));
      File(apk.path).copySync(dest);
      print('  → $dest');
    }

    // Copy AAB
    final aabPath = path.join(
      projectRoot, 'build', 'app', 'outputs', 'bundle',
      isRelease ? 'release' : 'debug', 'app-${isRelease ? "release" : "debug"}.aab',
    );
    if (File(aabPath).existsSync()) {
      final dest = path.join(distDir, 'flsingbox-android-v$version.aab');
      File(aabPath).copySync(dest);
      print('  → $dest');
    }
  }
}

// ===== Windows Builder =====
class WindowsBuilder extends PlatformBuilder {
  final String arch;

  WindowsBuilder({
    required super.config,
    required super.projectRoot,
    required super.outputDir,
    required super.coreDownloader,
    super.isRelease,
    this.arch = 'x64',
  });

  @override
  String get platformName => 'Windows ($arch)';

  @override
  Future<void> prepareCores() async {
    final corePath = await coreDownloader.download('windows', arch);
    final targetDir = path.join(projectRoot, 'windows', 'runner', 'resources');
    Directory(targetDir).createSync(recursive: true);
    File(corePath).copySync(path.join(targetDir, 'sing-box.exe'));
    // Also copy to assets for fallback resolution
    final assetsDir = path.join(projectRoot, 'assets', 'singbox');
    Directory(assetsDir).createSync(recursive: true);
    File(corePath).copySync(path.join(assetsDir, 'sing-box.exe'));
  }

  @override
  Future<void> package() async {
    final distDir = path.join(outputDir, 'windows');
    Directory(distDir).createSync(recursive: true);

    final version = config.appVersion;
    final buildDir = path.join(projectRoot, 'build', 'windows', arch, 'runner',
        isRelease ? 'Release' : 'Debug');

    // Inject sing-box.exe into build output at data/core/ for CorePathResolver
    final coreDest = path.join(buildDir, 'data', 'core');
    Directory(coreDest).createSync(recursive: true);
    final coreSource = path.join(projectRoot, 'assets', 'singbox', 'sing-box.exe');
    if (File(coreSource).existsSync()) {
      File(coreSource).copySync(path.join(coreDest, 'sing-box.exe'));
      // Also keep a copy at root level for backward compat
      File(coreSource).copySync(path.join(buildDir, 'sing-box.exe'));
    }

    // Create zip
    final zipName = 'flsingbox-windows-$arch-v$version.zip';
    final zipPath = path.join(distDir, zipName);
    await runCmd('powershell', [
      'Compress-Archive',
      '-Path', '$buildDir\\*',
      '-DestinationPath', zipPath,
      '-Force',
    ]);
    print('  → $zipPath');
  }

  @override
  Future<void> flutterBuild() async {
    final mode = isRelease ? '--release' : '--debug';
    final code = await runCmd('flutter', ['build', 'windows', mode]);
    if (code != 0) throw Exception('Flutter Windows build failed');
  }
}

// ===== macOS Builder =====
class MacOSBuilder extends PlatformBuilder {
  final String arch;

  MacOSBuilder({
    required super.config,
    required super.projectRoot,
    required super.outputDir,
    required super.coreDownloader,
    super.isRelease,
    this.arch = 'arm64',
  });

  @override
  String get platformName => 'macOS ($arch)';

  @override
  Future<void> prepareCores() async {
    final corePath = await coreDownloader.download('macos', arch);
    final assetsDir = path.join(projectRoot, 'assets', 'singbox');
    Directory(assetsDir).createSync(recursive: true);
    File(corePath).copySync(path.join(assetsDir, 'sing-box'));
  }

  @override
  Future<void> flutterBuild() async {
    final mode = isRelease ? '--release' : '--debug';
    final code = await runCmd('flutter', ['build', 'macos', mode]);
    if (code != 0) throw Exception('Flutter macOS build failed');
  }

  @override
  Future<void> package() async {
    final distDir = path.join(outputDir, 'macos');
    Directory(distDir).createSync(recursive: true);

    final version = config.appVersion;
    final appPath = path.join(
      projectRoot, 'build', 'macos', 'Build', 'Products',
      isRelease ? 'Release' : 'Debug', 'flsingbox.app',
    );

    // Inject core into app bundle at Contents/Resources/core/
    final coreDir = path.join(appPath, 'Contents', 'Resources', 'core');
    Directory(coreDir).createSync(recursive: true);
    final coreSource = path.join(projectRoot, 'assets', 'singbox', 'sing-box');
    if (File(coreSource).existsSync()) {
      File(coreSource).copySync(path.join(coreDir, 'sing-box'));
      await Process.run('chmod', ['+x', path.join(coreDir, 'sing-box')]);
    }

    // Create zip
    final zipName = 'flsingbox-macos-$arch-v$version.zip';
    final zipPath = path.join(distDir, zipName);
    await runCmd('ditto', ['-c', '-k', '--sequesterRsrc', appPath, zipPath]);
    print('  → $zipPath');
  }
}

// ===== Linux Builder =====
class LinuxBuilder extends PlatformBuilder {
  final String arch;

  LinuxBuilder({
    required super.config,
    required super.projectRoot,
    required super.outputDir,
    required super.coreDownloader,
    super.isRelease,
    this.arch = 'x64',
  });

  @override
  String get platformName => 'Linux ($arch)';

  @override
  Future<void> prepareCores() async {
    final corePath = await coreDownloader.download('linux', arch);
    final assetsDir = path.join(projectRoot, 'assets', 'singbox');
    Directory(assetsDir).createSync(recursive: true);
    File(corePath).copySync(path.join(assetsDir, 'sing-box'));
    await Process.run('chmod', ['+x', path.join(assetsDir, 'sing-box')]);
  }

  @override
  Future<void> flutterBuild() async {
    final mode = isRelease ? '--release' : '--debug';
    final code = await runCmd('flutter', ['build', 'linux', mode]);
    if (code != 0) throw Exception('Flutter Linux build failed');
  }

  @override
  Future<void> package() async {
    final distDir = path.join(outputDir, 'linux');
    Directory(distDir).createSync(recursive: true);

    final version = config.appVersion;
    final bundleDir = path.join(projectRoot, 'build', 'linux', arch, 'release', 'bundle');

    // Inject core to bundle at data/core/ for CorePathResolver
    final coreDest = path.join(bundleDir, 'data', 'core');
    Directory(coreDest).createSync(recursive: true);
    final coreSource = path.join(projectRoot, 'assets', 'singbox', 'sing-box');
    if (File(coreSource).existsSync()) {
      File(coreSource).copySync(path.join(coreDest, 'sing-box'));
      await Process.run('chmod', ['+x', path.join(coreDest, 'sing-box')]);
      // Also keep at root level for backward compat
      File(coreSource).copySync(path.join(bundleDir, 'sing-box'));
      await Process.run('chmod', ['+x', path.join(bundleDir, 'sing-box')]);
    }

    // Copy desktop file
    final desktopFile = path.join(projectRoot, 'linux', 'flsingbox.desktop');
    if (File(desktopFile).existsSync()) {
      File(desktopFile).copySync(path.join(bundleDir, 'flsingbox.desktop'));
    }

    // Create tar.gz
    final tarName = 'flsingbox-linux-$arch-v$version.tar.gz';
    final tarPath = path.join(distDir, tarName);
    await runCmd('tar', [
      'czf', tarPath,
      '-C', path.dirname(bundleDir),
      path.basename(bundleDir),
    ]);
    print('  → $tarPath');
  }
}

// ===== Checksum Generator =====
class ChecksumGenerator {
  static Future<void> generate(String distDir) async {
    print('\n═══ Generating checksums ═══');
    final checksumDir = path.join(distDir, 'checksums');
    Directory(checksumDir).createSync(recursive: true);

    final buffer = StringBuffer();
    final distDirectory = Directory(distDir);

    await for (final entity in distDirectory.list(recursive: true)) {
      if (entity is File && !entity.path.contains('checksums')) {
        final ext = path.extension(entity.path);
        if (['.apk', '.aab', '.zip', '.gz', '.exe', '.AppImage', '.dmg'].contains(ext)) {
          final result = await Process.run('sha256sum', [entity.path]);
          if (result.exitCode == 0) {
            final hash = (result.stdout as String).split(' ').first;
            final name = path.relative(entity.path, from: distDir);
            buffer.writeln('$hash  $name');
          }
        }
      }
    }

    final checksumFile = File(path.join(checksumDir, 'SHA256SUMS.txt'));
    checksumFile.writeAsStringSync(buffer.toString());
    print('  ✓ ${checksumFile.path}');
  }
}

// ===== Main =====
Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    exit(1);
  }

  final projectRoot = Directory.current.path;
  final config = VersionConfig.load(projectRoot);

  // Parse args
  final platform = args[0];
  final isRelease = !args.contains('--debug');
  final noCore = args.contains('--no-core');
  final archIndex = args.indexOf('--arch');
  final arch = archIndex >= 0 && archIndex + 1 < args.length ? args[archIndex + 1] : null;
  final outputIndex = args.indexOf('--output');
  final outputDir = outputIndex >= 0 && outputIndex + 1 < args.length
      ? args[outputIndex + 1]
      : path.join(projectRoot, 'dist');

  // Override core version
  final coreVersionIndex = args.indexOf('--core-version');
  if (coreVersionIndex >= 0 && coreVersionIndex + 1 < args.length) {
    // Would need mutable config - skip for now, use version.json
  }

  print('╔══════════════════════════════════════════╗');
  print('║       FLSingBox Build System             ║');
  print('╚══════════════════════════════════════════╝');
  print('  App Version:  ${config.appVersion}');
  print('  Core Version: ${config.coreVersion}');
  print('  Channel:      ${config.releaseChannel}');
  print('  Mode:         ${isRelease ? "Release" : "Debug"}');
  print('  Output:       $outputDir');

  Directory(outputDir).createSync(recursive: true);

  final coreDownloader = CoreDownloader(config, projectRoot);

  try {
    switch (platform) {
      case 'android':
        final builder = AndroidBuilder(
          config: config,
          projectRoot: projectRoot,
          outputDir: outputDir,
          coreDownloader: coreDownloader,
          isRelease: isRelease,
        );
        if (!noCore) await builder.prepareCores();
        await builder.flutterBuild();
        await builder.package();

      case 'windows':
        final builder = WindowsBuilder(
          config: config,
          projectRoot: projectRoot,
          outputDir: outputDir,
          coreDownloader: coreDownloader,
          isRelease: isRelease,
          arch: arch ?? 'x64',
        );
        await builder.build();

      case 'macos':
        final builder = MacOSBuilder(
          config: config,
          projectRoot: projectRoot,
          outputDir: outputDir,
          coreDownloader: coreDownloader,
          isRelease: isRelease,
          arch: arch ?? 'arm64',
        );
        await builder.build();

      case 'linux':
        final builder = LinuxBuilder(
          config: config,
          projectRoot: projectRoot,
          outputDir: outputDir,
          coreDownloader: coreDownloader,
          isRelease: isRelease,
          arch: arch ?? 'x64',
        );
        await builder.build();

      case 'all':
        print('\n  Building all platforms...');
        // Platform check - only build what's possible on current OS
        if (Platform.isLinux) {
          await LinuxBuilder(
            config: config, projectRoot: projectRoot, outputDir: outputDir,
            coreDownloader: coreDownloader, isRelease: isRelease,
          ).build();
          await AndroidBuilder(
            config: config, projectRoot: projectRoot, outputDir: outputDir,
            coreDownloader: coreDownloader, isRelease: isRelease,
          ).build();
        } else if (Platform.isWindows) {
          await WindowsBuilder(
            config: config, projectRoot: projectRoot, outputDir: outputDir,
            coreDownloader: coreDownloader, isRelease: isRelease,
          ).build();
        } else if (Platform.isMacOS) {
          await MacOSBuilder(
            config: config, projectRoot: projectRoot, outputDir: outputDir,
            coreDownloader: coreDownloader, isRelease: isRelease,
          ).build();
        }

      case 'core':
        print('\n  Downloading cores only...');
        final p = Platform.isWindows ? 'windows' : (Platform.isMacOS ? 'macos' : 'linux');
        await coreDownloader.download(p, arch ?? 'x64');

      case 'clean':
        print('\n  Cleaning...');
        final dirs = [
          path.join(projectRoot, 'dist'),
          path.join(projectRoot, '.cache', 'core'),
          path.join(projectRoot, 'build'),
        ];
        for (final d in dirs) {
          if (Directory(d).existsSync()) {
            Directory(d).deleteSync(recursive: true);
            print('  ✓ Removed $d');
          }
        }
        print('  ✓ Clean complete');
        return;

      default:
        print('  ✗ Unknown platform: $platform');
        _printUsage();
        exit(1);
    }

    // Generate checksums
    if (platform != 'clean' && platform != 'core') {
      await ChecksumGenerator.generate(outputDir);
    }

    print('\n╔══════════════════════════════════════════╗');
    print('║       Build Complete!                    ║');
    print('╚══════════════════════════════════════════╝');
  } catch (e) {
    print('\n  ✗ Build failed: $e');
    exit(1);
  }
}

void _printUsage() {
  print('''
Usage: dart tool/setup.dart <platform> [options]

Platforms:
  android    Build Android APK/AAB
  windows    Build Windows executable + zip
  macos      Build macOS application
  linux      Build Linux application
  all        Build all platforms (current OS only)
  core       Download sing-box core only
  clean      Clean build artifacts

Options:
  --arch <arch>         Target architecture (x64, arm64)
  --release             Release mode (default)
  --debug               Debug mode
  --no-core             Skip core download
  --core-version <v>    Override sing-box version
  --output <dir>        Output directory (default: dist/)

Examples:
  dart tool/setup.dart android
  dart tool/setup.dart windows --arch x64
  dart tool/setup.dart linux --arch x64 --release
  dart tool/setup.dart clean
''');
}
