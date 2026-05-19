import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/subscription/subscription.dart';
import '../../repositories/subscription_repository.dart';

const _uuid = Uuid();

class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('订阅管理')),
      body: StreamBuilder<List<Subscription>>(
        stream: ref.read(subscriptionRepositoryProvider).watchAll(),
        builder: (ctx, snap) {
          final subs = snap.data ?? [];
          if (subs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.subscriptions_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  const Text('暂无订阅'),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('添加订阅'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: subs.length,
            itemBuilder: (ctx, i) => _SubscriptionCard(
              subscription: subs[i],
              onSync: () => _syncSubscription(subs[i]),
              onEdit: () => _editSubscription(subs[i]),
              onDelete: () => _deleteSubscription(subs[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('添加订阅'),
      ),
    );
  }

  void _showAddDialog({Subscription? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final urlCtrl = TextEditingController(text: existing?.url ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? '添加订阅' : '编辑订阅'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: '订阅名称'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlCtrl,
              decoration: const InputDecoration(
                labelText: '订阅地址',
                hintText: 'https://...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final url = urlCtrl.text.trim();
              if (url.isEmpty) return;
              Navigator.pop(ctx);
              final now = DateTime.now();
              final sub = existing?.copyWith(
                    name: nameCtrl.text.trim(),
                    url: url,
                    updatedAt: now,
                  ) ??
                  Subscription(
                    id: _uuid.v4(),
                    name: nameCtrl.text.trim().isEmpty
                        ? '订阅 ${DateTime.now().millisecondsSinceEpoch}'
                        : nameCtrl.text.trim(),
                    url: url,
                    createdAt: now,
                    updatedAt: now,
                  );
              await ref.read(subscriptionRepositoryProvider).save(sub);
              // Auto-sync on add
              if (existing == null) _syncSubscription(sub);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Future<void> _syncSubscription(Subscription sub) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('正在更新 ${sub.name}...')),
    );
    final result =
        await ref.read(subscriptionRepositoryProvider).sync(sub);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.error ??
                '更新完成: 新增 ${result.added}, 移除 ${result.removed}',
          ),
        ),
      );
    }
  }

  void _editSubscription(Subscription sub) {
    _showAddDialog(existing: sub);
  }

  Future<void> _deleteSubscription(Subscription sub) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除订阅'),
        content: Text('确定删除「${sub.name}」？关联的节点也将被删除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(subscriptionRepositoryProvider).delete(sub.id);
    }
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onSync;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubscriptionCard({
    required this.subscription,
    required this.onSync,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    subscription.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (!subscription.enabled)
                  const Chip(
                    label: Text('已禁用'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subscription.url,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.dns, size: 14, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text('${subscription.nodeCount} 节点',
                    style: theme.textTheme.bodySmall),
                const SizedBox(width: 12),
                Icon(Icons.access_time,
                    size: 14, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  subscription.lastUpdateTime != null
                      ? _timeAgo(subscription.lastUpdateTime!)
                      : '未更新',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onSync,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('更新'),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('编辑'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon:
                      const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  label: const Text(
                    '删除',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }
}
