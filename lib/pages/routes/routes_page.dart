import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/route/route_rule.dart';
import '../../providers/app_providers.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class RoutesPage extends ConsumerWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(routeRulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('路由规则'),
        actions: [
          SegmentedButton<String>(
            selected: {ref.watch(proxyModeProvider).name},
            onSelectionChanged: (v) {
              ref.read(proxyModeProvider.notifier).state =
                  ProxyMode.values.firstWhere((m) => m.name == v.first);
            },
            segments: const [
              ButtonSegment(value: 'rule', label: Text('规则')),
              ButtonSegment(value: 'global', label: Text('全局')),
              ButtonSegment(value: 'direct', label: Text('直连')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: rules.isEmpty
          ? const Center(child: Text('暂无自定义规则'))
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rules.length,
              onReorder: (oldIdx, newIdx) {
                // reorder logic
              },
              itemBuilder: (ctx, i) => Card(
                key: Key(rules[i].id),
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  leading: Icon(
                    rules[i].enabled
                        ? Icons.check_circle
                        : Icons.radio_button_off,
                    color: rules[i].enabled ? Colors.green : Colors.grey,
                  ),
                  title: Text(rules[i].value),
                  subtitle: Text(
                    '${rules[i].type.displayName} → ${rules[i].outboundType.displayName}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(routeRulesProvider.notifier)
                        .removeRule(rules[i].id),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRule(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('添加规则'),
      ),
    );
  }

  void _showAddRule(BuildContext context, WidgetRef ref) {
    final valueCtrl = TextEditingController();
    var type = RouteRuleType.domain;
    var outboundType = RouteOutboundType.direct;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('添加路由规则'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<RouteRuleType>(
                value: type,
                decoration: const InputDecoration(labelText: '规则类型'),
                items: RouteRuleType.values
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)))
                    .toList(),
                onChanged: (v) => setState(() => type = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueCtrl,
                decoration: const InputDecoration(
                  labelText: '规则值',
                  hintText: '如 google.com 或 cn',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RouteOutboundType>(
                value: outboundType,
                decoration: const InputDecoration(labelText: '出站目标'),
                items: RouteOutboundType.values
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)))
                    .toList(),
                onChanged: (v) => setState(() => outboundType = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (valueCtrl.text.trim().isEmpty) return;
                ref.read(routeRulesProvider.notifier).addRule(
                      RouteRule(
                        id: _uuid.v4(),
                        type: type,
                        value: valueCtrl.text.trim(),
                        outboundType: outboundType,
                        orderIndex: ref.read(routeRulesProvider).length,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }
}
