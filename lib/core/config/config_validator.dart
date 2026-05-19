import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../manager/core_path_resolver.dart';

/// 配置验证结果
class ConfigValidationResult {
  final bool valid;
  final List<String> errors;
  final List<String> warnings;

  const ConfigValidationResult({
    required this.valid,
    this.errors = const [],
    this.warnings = const [],
  });

  factory ConfigValidationResult.success({List<String> warnings = const []}) =>
      ConfigValidationResult(valid: true, warnings: warnings);

  factory ConfigValidationResult.failure(List<String> errors,
          {List<String> warnings = const []}) =>
      ConfigValidationResult(valid: false, errors: errors, warnings: warnings);

  String get summary {
    if (valid) {
      if (warnings.isEmpty) return '配置有效';
      return '配置有效 (${warnings.length} 个警告)';
    }
    return '配置无效: ${errors.join("; ")}';
  }
}

/// 配置验证器
/// 在启动核心前验证配置文件的完整性和合法性
class ConfigValidator {
  final CorePathResolver _pathResolver;

  ConfigValidator(this._pathResolver);

  /// 完整验证流程
  Future<ConfigValidationResult> validate(String configPath) async {
    final errors = <String>[];
    final warnings = <String>[];

    // 1. 文件存在性检查
    if (!File(configPath).existsSync()) {
      return ConfigValidationResult.failure(['配置文件不存在: $configPath']);
    }

    // 2. JSON 合法性检查
    final jsonResult = _validateJson(configPath);
    if (!jsonResult.valid) {
      return jsonResult;
    }

    // 3. 必填字段检查
    final content = File(configPath).readAsStringSync();
    final config = jsonDecode(content) as Map<String, dynamic>;
    final fieldResult = _validateRequiredFields(config);
    errors.addAll(fieldResult.errors);
    warnings.addAll(fieldResult.warnings);

    // 4. 出站链路合法性检查
    final outboundResult = _validateOutbounds(config);
    errors.addAll(outboundResult.errors);
    warnings.addAll(outboundResult.warnings);

    // 5. 使用 sing-box check 命令做最终验证
    final checkResult = await _runSingBoxCheck(configPath);
    if (!checkResult.valid) {
      errors.addAll(checkResult.errors);
    }

    if (errors.isEmpty) {
      return ConfigValidationResult.success(warnings: warnings);
    }
    return ConfigValidationResult.failure(errors, warnings: warnings);
  }

  /// 仅做 JSON 语法验证（快速）
  ConfigValidationResult _validateJson(String configPath) {
    try {
      final content = File(configPath).readAsStringSync();
      jsonDecode(content);
      return ConfigValidationResult.success();
    } on FormatException catch (e) {
      return ConfigValidationResult.failure(['JSON 语法错误: ${e.message}']);
    } catch (e) {
      return ConfigValidationResult.failure(['读取配置文件失败: $e']);
    }
  }

  /// 检查必填字段
  ConfigValidationResult _validateRequiredFields(Map<String, dynamic> config) {
    final errors = <String>[];
    final warnings = <String>[];

    // 必须有 outbounds
    if (!config.containsKey('outbounds') ||
        (config['outbounds'] as List?)?.isEmpty == true) {
      errors.add('配置缺少 outbounds 定义');
    }

    // 建议有 inbounds
    if (!config.containsKey('inbounds') ||
        (config['inbounds'] as List?)?.isEmpty == true) {
      warnings.add('配置未定义 inbounds，核心可能无法接收流量');
    }

    // 建议有 dns
    if (!config.containsKey('dns')) {
      warnings.add('配置未定义 DNS，将使用系统 DNS');
    }

    return ConfigValidationResult(
      valid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// 检查出站链路合法性
  ConfigValidationResult _validateOutbounds(Map<String, dynamic> config) {
    final errors = <String>[];
    final warnings = <String>[];

    final outbounds = config['outbounds'] as List?;
    if (outbounds == null || outbounds.isEmpty) return ConfigValidationResult.success();

    final tags = <String>{};
    for (final ob in outbounds) {
      final tag = ob['tag'] as String?;
      if (tag == null || tag.isEmpty) {
        errors.add('存在未命名的出站');
        continue;
      }
      if (tags.contains(tag)) {
        errors.add('出站 tag 重复: $tag');
      }
      tags.add(tag);
    }

    // 检查 selector/urltest 中引用的出站是否存在
    for (final ob in outbounds) {
      final type = ob['type'] as String?;
      if (type == 'selector' || type == 'urltest') {
        final refs = ob['outbounds'] as List?;
        if (refs != null) {
          for (final ref in refs) {
            if (!tags.contains(ref as String)) {
              warnings.add('${ob['tag']} 引用了不存在的出站: $ref');
            }
          }
        }
      }
      // 检查 detour 引用
      final detour = ob['detour'] as String?;
      if (detour != null && !tags.contains(detour)) {
        warnings.add('${ob['tag']} 的 detour 引用了不存在的出站: $detour');
      }
    }

    // 检查必要的固定出站
    if (!tags.contains('direct')) {
      warnings.add('缺少 direct 出站');
    }

    return ConfigValidationResult(
      valid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// 使用 sing-box 命令验证
  Future<ConfigValidationResult> _runSingBoxCheck(String configPath) async {
    final binaryPath = await _pathResolver.resolve();
    if (binaryPath == null) {
      // 没有核心也通过，仅做前置检查
      return ConfigValidationResult.success(
        warnings: ['未找到核心，跳过 sing-box check 验证'],
      );
    }

    try {
      final result = await Process.run(binaryPath, ['check', '-c', configPath]);
      if (result.exitCode == 0) {
        return ConfigValidationResult.success();
      }
      final stderr = (result.stderr as String).trim();
      final stdout = (result.stdout as String).trim();
      final msg = stderr.isNotEmpty ? stderr : stdout;
      return ConfigValidationResult.failure(['sing-box check 失败: $msg']);
    } catch (e) {
      return ConfigValidationResult.success(
        warnings: ['sing-box check 执行失败: $e'],
      );
    }
  }
}

/// 运行时配置管理
/// 负责配置文件的写入、备份和路径管理
class RuntimeConfigManager {
  final CorePathResolver _pathResolver;
  final ConfigValidator _validator;

  RuntimeConfigManager(this._pathResolver)
      : _validator = ConfigValidator(_pathResolver);

  ConfigValidator get validator => _validator;

  /// 写入运行时配置并验证
  Future<({String path, ConfigValidationResult validation})> writeAndValidate(
    Map<String, dynamic> config,
  ) async {
    final configDir = await _pathResolver.getConfigDirectory();
    final configPath = p.join(configDir, 'config.json');

    // 写入配置
    final content = const JsonEncoder.withIndent('  ').convert(config);
    await File(configPath).writeAsString(content);

    // 验证
    final result = await _validator.validate(configPath);

    // 如果验证通过，备份为 last_good_config.json
    if (result.valid) {
      final backupPath = p.join(configDir, 'last_good_config.json');
      await File(configPath).copy(backupPath);
    }

    return (path: configPath, validation: result);
  }

  /// 仅写入配置（不验证）
  Future<String> writeConfig(Map<String, dynamic> config) async {
    final configDir = await _pathResolver.getConfigDirectory();
    final configPath = p.join(configDir, 'config.json');
    final content = const JsonEncoder.withIndent('  ').convert(config);
    await File(configPath).writeAsString(content);
    return configPath;
  }

  /// 获取上次成功的配置
  Future<String?> getLastGoodConfig() async {
    final configDir = await _pathResolver.getConfigDirectory();
    final backupPath = p.join(configDir, 'last_good_config.json');
    if (File(backupPath).existsSync()) {
      return File(backupPath).readAsStringSync();
    }
    return null;
  }

  /// 获取当前运行配置内容
  Future<String?> getCurrentConfig() async {
    final configDir = await _pathResolver.getConfigDirectory();
    final configPath = p.join(configDir, 'config.json');
    if (File(configPath).existsSync()) {
      return File(configPath).readAsStringSync();
    }
    return null;
  }

  /// 获取当前配置路径
  Future<String> getConfigPath() async {
    final configDir = await _pathResolver.getConfigDirectory();
    return p.join(configDir, 'config.json');
  }
}
