import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/node_repository.dart';
import '../../models/node/node.dart';

class ChainProxyPage extends ConsumerWidget {
  const ChainProxyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('链式代理')),
      body: StreamBuilder<List<Node>>(
        stream: ref.read(nodeRepositoryProvider).watchAll(),
        builder: (ctx, snap) {
          final nodes = snap.data ?? [];
          final chainNodes = nodes.where((n) => n.hasDetour).toList();

          if (chainNodes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link, size: 64,
                        color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    const Text('暂无链式代理'),
                    const SizedBox(height: 8),
                    Text(
                      '链式代理基于 sing-box 的 detour 功能，\n允许节点通过另一个节点出站。',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '使用方法:\n1. 在节点编辑页面设置 detour 目标\n2. 确保目标节点已启用\n3. 避免循环引用',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: chainNodes.length,
            itemBuilder: (ctx, i) {
              final node = chainNodes[i];
              final target = nodes
                  .where((n) => n.id == node.detourTargetId)
                  .firstOrNull;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(node.displayName,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            avatar: const Icon(Icons.dns, size: 16),
                            label: Text(node.displayName),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, size: 16),
                          ),
                          Chip(
                            avatar: const Icon(Icons.dns, size: 16),
                            label: Text(
                              target?.displayName ?? '目标不存在',
                            ),
                            backgroundColor: target == null
                                ? Colors.red.withOpacity(0.1)
                                : null,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, size: 16),
                          ),
                          const Chip(
                            avatar: Icon(Icons.public, size: 16),
                            label: Text('互联网'),
                          ),
                        ],
                      ),
                      if (target == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            '⚠️ 链路目标节点不存在或已被删除',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
