import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../models/group/node_group.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(nodeGroupsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('分组管理')),
      body: groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_outlined,
                      size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  const Text('暂无分组'),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _showAddDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('创建分组'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: groups.length,
              itemBuilder: (ctx, i) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    groups[i].type == NodeGroupType.urltest
                        ? Icons.speed
                        : Icons.list,
                  ),
                  title: Text(groups[i].name),
                  subtitle: Text(
                    '${groups[i].type.displayName} · ${groups[i].nodeIds.length} 节点',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'delete') {
                        ref.read(nodeGroupsProvider.notifier).removeGroup(groups[i].id);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('编辑')),
                      const PopupMenuItem(value: 'delete', child: Text('删除')),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('创建分组'),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    var type = NodeGroupType.selector;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('创建分组'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: '分组名称'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<NodeGroupType>(
                value: type,
                decoration: const InputDecoration(labelText: '分组类型'),
                items: NodeGroupType.values
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)))
                    .toList(),
                onChanged: (v) => setState(() => type = v ?? NodeGroupType.selector),
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
                if (nameCtrl.text.trim().isEmpty) return;
                final now = DateTime.now();
                ref.read(nodeGroupsProvider.notifier).addGroup(
                      NodeGroup(
                        id: _uuid.v4(),
                        name: nameCtrl.text.trim(),
                        type: type,
                        createdAt: now,
                        updatedAt: now,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: const Text('创建'),
            ),
          ],
        ),
      ),
    );
  }
}
