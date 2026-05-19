import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/singbox/singbox_config_builder.dart';
import '../../core/singbox/singbox_controller.dart';
import '../../repositories/node_repository.dart';
import '../../providers/app_providers.dart';

class ConfigPreviewPage extends ConsumerWidget {
  const ConfigPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('配置预览'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () => _checkConfig(context, ref),
            tooltip: '校验配置',
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyConfig(context, ref),
            tooltip: '复制',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _buildConfig(ref),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final json = const JsonEncoder.withIndent('  ').convert(snap.data!);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              json,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _buildConfig(WidgetRef ref) async {
    final nodeRepo = ref.read(nodeRepositoryProvider);
    final nodes = await nodeRepo.getAll();
    final groups = ref.read(nodeGroupsProvider);
    final rules = ref.read(routeRulesProvider);
    final mode = ref.read(proxyModeProvider);
    final selectedId = ref.read(selectedNodeIdProvider);

    return SingBoxConfigBuilder(
      nodes: nodes,
      groups: groups,
      routeRules: rules,
      proxyMode: mode.name,
      selectedNodeId: selectedId,
      clashApiPort: '9090',
    ).build();
  }

  Future<void> _checkConfig(BuildContext context, WidgetRef ref) async {
    final config = await _buildConfig(ref);
    final ctrl = ref.read(singBoxControllerProvider.notifier);
    final result = await ctrl.checkConfig(config);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(result.valid ? '✅ 配置合法' : '❌ 配置有误'),
          content: Text(result.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _copyConfig(BuildContext context, WidgetRef ref) async {
    final config = await _buildConfig(ref);
    final json = const JsonEncoder.withIndent('  ').convert(config);
    await Clipboard.setData(ClipboardData(text: json));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('配置已复制到剪贴板')),
      );
    }
  }
}
