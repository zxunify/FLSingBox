import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/node/node.dart';
import '../../models/protocol_type.dart';
import '../../models/node_source_type.dart';
import '../../repositories/node_repository.dart';
import '../../providers/app_providers.dart';

class NodesPage extends ConsumerStatefulWidget {
  const NodesPage({super.key});

  @override
  ConsumerState<NodesPage> createState() => _NodesPageState();
}

class _NodesPageState extends ConsumerState<NodesPage> {
  String _searchQuery = '';
  ProtocolType? _filterProtocol;
  NodeSourceType? _filterSource;
  bool? _filterEnabled;
  bool? _filterFavorite;
  String _sortField = 'name'; // name, latency, created_at
  final Set<String> _selected = {};
  bool _selectMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectMode
            ? Text('已选 ${_selected.length} 个')
            : const Text('节点管理'),
        actions: _buildActions(),
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (q) => setState(() => _searchQuery = q),
            onFilter: _showFilterSheet,
          ),
          Expanded(child: _buildNodeList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/nodes/edit'),
        icon: const Icon(Icons.add),
        label: const Text('手动添加'),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_selectMode) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() {
            _selectMode = false;
            _selected.clear();
          }),
        ),
        PopupMenuButton<String>(
          onSelected: _onBatchAction,
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'enable', child: Text('批量启用')),
            const PopupMenuItem(value: 'disable', child: Text('批量禁用')),
            const PopupMenuItem(value: 'delete', child: Text('批量删除')),
            const PopupMenuItem(value: 'export', child: Text('批量导出')),
            const PopupMenuItem(value: 'test', child: Text('批量测速')),
          ],
        ),
      ];
    }
    return [
      IconButton(
        icon: const Icon(Icons.sort),
        onPressed: _showSortSheet,
        tooltip: '排序',
      ),
      IconButton(
        icon: const Icon(Icons.file_upload_outlined),
        onPressed: () => context.push('/import'),
        tooltip: '导入',
      ),
    ];
  }

  Widget _buildNodeList() {
    return StreamBuilder<List<Node>>(
      stream: ref.read(nodeRepositoryProvider).watchAll(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var nodes = snap.data ?? [];

        // 搜索过滤
        if (_searchQuery.isNotEmpty) {
          nodes = nodes
              .where(
                (n) =>
                    n.displayName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                    n.server.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
        }

        // 协议过滤
        if (_filterProtocol != null) {
          nodes = nodes
              .where((n) => n.protocolType == _filterProtocol)
              .toList();
        }

        // 来源过滤
        if (_filterSource != null) {
          nodes =
              nodes.where((n) => n.sourceType == _filterSource).toList();
        }

        // 启用/禁用过滤
        if (_filterEnabled != null) {
          nodes =
              nodes.where((n) => n.enabled == _filterEnabled).toList();
        }

        // 收藏过滤
        if (_filterFavorite == true) {
          nodes = nodes.where((n) => n.isFavorite).toList();
        }

        // 排序
        nodes = _sortNodes(nodes);

        if (nodes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dns_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty ? '无匹配节点' : '暂无节点',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 8),
                if (_searchQuery.isEmpty) ...[
                  FilledButton.icon(
                    onPressed: () => context.push('/import'),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text('导入节点'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/nodes/edit'),
                    icon: const Icon(Icons.add),
                    label: const Text('手动添加'),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: nodes.length,
          itemBuilder: (ctx, i) => NodeCard(
            node: nodes[i],
            isSelected: _selected.contains(nodes[i].id),
            selectMode: _selectMode,
            onTap: () => _onNodeTap(nodes[i]),
            onLongPress: () => _onNodeLongPress(nodes[i]),
            onActionSelected: (action) =>
                _onNodeAction(nodes[i], action),
          ),
        );
      },
    );
  }

  List<Node> _sortNodes(List<Node> nodes) {
    switch (_sortField) {
      case 'latency':
        return nodes
          ..sort(
            (a, b) => (a.latencyMs ?? 999999)
                .compareTo(b.latencyMs ?? 999999),
          );
      case 'created_at':
        return nodes..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 'name':
      default:
        return nodes
          ..sort(
            (a, b) =>
                a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
          );
    }
  }

  void _onNodeTap(Node node) {
    if (_selectMode) {
      setState(() {
        if (_selected.contains(node.id)) {
          _selected.remove(node.id);
        } else {
          _selected.add(node.id);
        }
      });
    } else {
      context.push('/nodes/edit?id=${node.id}');
    }
  }

  void _onNodeLongPress(Node node) {
    setState(() {
      _selectMode = true;
      _selected.add(node.id);
    });
  }

  void _onNodeAction(Node node, String action) async {
    final repo = ref.read(nodeRepositoryProvider);
    switch (action) {
      case 'select':
        ref.read(selectedNodeIdProvider.notifier).state = node.id;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已选择 ${node.displayName}')),
        );
        break;
      case 'favorite':
        await repo.save(
          node.copyWith(isFavorite: !node.isFavorite, updatedAt: DateTime.now()),
        );
        break;
      case 'toggle':
        await repo.save(
          node.copyWith(enabled: !node.enabled, updatedAt: DateTime.now()),
        );
        break;
      case 'delete':
        final ok = await _confirmDelete(node.displayName);
        if (ok) await repo.delete(node.id);
        break;
      case 'export':
        _exportNode(context, node);
        break;
    }
  }

  Future<bool> _confirmDelete(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('确认删除'),
            content: Text('确定删除节点「$name」？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('删除'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _exportNode(BuildContext context, Node node) {
    if (node.rawUri != null) {
      // TODO: copy to clipboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已复制 ${node.displayName} 的 URI')),
      );
    }
  }

  void _onBatchAction(String action) async {
    final repo = ref.read(nodeRepositoryProvider);
    switch (action) {
      case 'enable':
        final nodes = await repo.getAll();
        for (final n in nodes.where((n) => _selected.contains(n.id))) {
          await repo.save(
            n.copyWith(enabled: true, updatedAt: DateTime.now()),
          );
        }
        break;
      case 'disable':
        final nodes = await repo.getAll();
        for (final n in nodes.where((n) => _selected.contains(n.id))) {
          await repo.save(
            n.copyWith(enabled: false, updatedAt: DateTime.now()),
          );
        }
        break;
      case 'delete':
        final ok = await _confirmDelete('${_selected.length} 个节点');
        if (ok) {
          for (final id in _selected) {
            await repo.delete(id);
          }
        }
        break;
    }
    setState(() {
      _selectMode = false;
      _selected.clear();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _FilterSheet(
        currentProtocol: _filterProtocol,
        currentSource: _filterSource,
        currentEnabled: _filterEnabled,
        currentFavorite: _filterFavorite,
        onApply: (proto, src, enabled, fav) {
          setState(() {
            _filterProtocol = proto;
            _filterSource = src;
            _filterEnabled = enabled;
            _filterFavorite = fav;
          });
        },
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(title: Text('排序方式', style: TextStyle(fontWeight: FontWeight.bold))),
          RadioListTile(
            value: 'name',
            groupValue: _sortField,
            title: const Text('名称'),
            onChanged: (v) {
              setState(() => _sortField = v!);
              Navigator.pop(context);
            },
          ),
          RadioListTile(
            value: 'latency',
            groupValue: _sortField,
            title: const Text('延迟'),
            onChanged: (v) {
              setState(() => _sortField = v!);
              Navigator.pop(context);
            },
          ),
          RadioListTile(
            value: 'created_at',
            groupValue: _sortField,
            title: const Text('添加时间'),
            onChanged: (v) {
              setState(() => _sortField = v!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class NodeCard extends StatelessWidget {
  final Node node;
  final bool isSelected;
  final bool selectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final void Function(String action) onActionSelected;

  const NodeCard({
    super.key,
    required this.node,
    required this.isSelected,
    required this.selectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latencyColor = _latencyColor(node.latencyMs);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 协议徽章
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _protocolColor(node.protocolType).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _protocolShort(node.protocolType),
                    style: TextStyle(
                      color: _protocolColor(node.protocolType),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 节点信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (node.isPinned)
                          const Icon(Icons.push_pin, size: 14, color: Colors.orange),
                        if (node.isFavorite)
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                        Expanded(
                          child: Text(
                            node.displayName,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${node.server}:${node.port}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        _SourceBadge(sourceType: node.sourceType),
                        if (node.hasDetour)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '链式',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // 延迟
              if (node.latencyMs != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    node.latencyDisplay,
                    style: TextStyle(
                      color: latencyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // 操作
              if (selectMode)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                )
              else
                PopupMenuButton<String>(
                  onSelected: onActionSelected,
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'select',
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('设为当前节点'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'favorite',
                      child: ListTile(
                        leading: Icon(
                          node.isFavorite ? Icons.star : Icons.star_outline,
                        ),
                        title: Text(node.isFavorite ? '取消收藏' : '收藏'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: ListTile(
                        leading: Icon(
                          node.enabled ? Icons.toggle_on : Icons.toggle_off,
                        ),
                        title: Text(node.enabled ? '禁用' : '启用'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: ListTile(
                        leading: Icon(Icons.share),
                        title: Text('导出 URI'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('删除', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _latencyColor(int? ms) {
    if (ms == null) return Colors.grey;
    if (ms < 100) return Colors.green;
    if (ms < 300) return Colors.orange;
    return Colors.red;
  }

  Color _protocolColor(ProtocolType type) {
    switch (type) {
      case ProtocolType.shadowsocks:
        return Colors.teal;
      case ProtocolType.vmess:
        return Colors.blue;
      case ProtocolType.vless:
        return Colors.indigo;
      case ProtocolType.trojan:
        return Colors.purple;
      case ProtocolType.hysteria2:
        return Colors.orange;
      case ProtocolType.tuic:
        return Colors.cyan;
      case ProtocolType.wireguard:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _protocolShort(ProtocolType type) {
    switch (type) {
      case ProtocolType.shadowsocks:
        return 'SS';
      case ProtocolType.vmess:
        return 'VM';
      case ProtocolType.vless:
        return 'VL';
      case ProtocolType.trojan:
        return 'TR';
      case ProtocolType.hysteria2:
        return 'HY2';
      case ProtocolType.tuic:
        return 'TUIC';
      case ProtocolType.wireguard:
        return 'WG';
      case ProtocolType.socks:
        return 'SK';
      case ProtocolType.http:
        return 'HTTP';
      default:
        return '?';
    }
  }
}

class _SourceBadge extends StatelessWidget {
  final NodeSourceType sourceType;
  const _SourceBadge({required this.sourceType});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (sourceType) {
      NodeSourceType.subscription => (Colors.blue, '订阅'),
      NodeSourceType.manual => (Colors.green, '手动'),
      NodeSourceType.clipboard => (Colors.orange, '剪贴板'),
      NodeSourceType.fileImport => (Colors.purple, '文件'),
      _ => (Colors.grey, sourceType.displayName),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final void Function(String) onChanged;
  final VoidCallback onFilter;

  const _SearchBar({required this.onChanged, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: '搜索节点...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.outlined(
            onPressed: onFilter,
            icon: const Icon(Icons.filter_list),
            tooltip: '筛选',
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final ProtocolType? currentProtocol;
  final NodeSourceType? currentSource;
  final bool? currentEnabled;
  final bool? currentFavorite;
  final void Function(
    ProtocolType?,
    NodeSourceType?,
    bool?,
    bool?,
  ) onApply;

  const _FilterSheet({
    required this.currentProtocol,
    required this.currentSource,
    required this.currentEnabled,
    required this.currentFavorite,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  ProtocolType? _protocol;
  NodeSourceType? _source;
  bool? _enabled;
  bool? _favorite;

  @override
  void initState() {
    super.initState();
    _protocol = widget.currentProtocol;
    _source = widget.currentSource;
    _enabled = widget.currentEnabled;
    _favorite = widget.currentFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '筛选',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _protocol = null;
                    _source = null;
                    _enabled = null;
                    _favorite = null;
                  });
                },
                child: const Text('重置'),
              ),
            ],
          ),
          const Text('协议类型'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ProtocolType.values
                .where((p) => p != ProtocolType.unknown)
                .map(
                  (p) => FilterChip(
                    label: Text(p.displayName),
                    selected: _protocol == p,
                    onSelected: (v) =>
                        setState(() => _protocol = v ? p : null),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('来源'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: NodeSourceType.values
                .map(
                  (s) => FilterChip(
                    label: Text(s.displayName),
                    selected: _source == s,
                    onSelected: (v) =>
                        setState(() => _source = v ? s : null),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_protocol, _source, _enabled, _favorite);
                    Navigator.pop(context);
                  },
                  child: const Text('应用筛选'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
