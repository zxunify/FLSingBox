import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/import/import_task.dart';
import '../../models/node_source_type.dart';
import '../../repositories/node_repository.dart';

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  final _textCtrl = TextEditingController();
  ImportTask? _lastResult;
  bool _importing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导入节点')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 输入方式
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '粘贴节点 URI',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '支持 ss:// vmess:// vless:// trojan:// hysteria2:// tuic:// socks:// 多行批量',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _textCtrl,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: '每行一个节点 URI...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _importing ? null : _importFromText,
                          icon: const Icon(Icons.file_download),
                          label: const Text('导入'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.paste),
                        label: const Text('从剪贴板粘贴'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 文件导入
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('从文件导入'),
              subtitle: const Text('支持 txt/json/yaml 文件'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _importFromFile,
            ),
          ),
          const SizedBox(height: 16),

          // 导入结果
          if (_lastResult != null) _ImportReport(task: _lastResult!),
        ],
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      _textCtrl.text = data!.text!;
    }
  }

  Future<void> _importFromText() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _importing = true);
    final result = await ref.read(nodeRepositoryProvider).importFromText(
          text,
          sourceType: NodeSourceType.manual,
        );
    setState(() {
      _importing = false;
      _lastResult = result;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '导入完成: ${result.successCount} 成功, ${result.failedCount} 失败, ${result.duplicateCount} 重复',
          ),
        ),
      );
    }
  }

  Future<void> _importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'json', 'yaml', 'yml'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final content = await Future.value(
      String.fromCharCodes(file.bytes ?? []),
    );

    if (content.isEmpty) return;

    setState(() => _importing = true);
    final importResult = await ref.read(nodeRepositoryProvider).importFromText(
          content,
          sourceType: NodeSourceType.fileImport,
        );
    setState(() {
      _importing = false;
      _lastResult = importResult;
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }
}

class _ImportReport extends StatelessWidget {
  final ImportTask task;
  const _ImportReport({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '导入报告',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '成功',
                  value: '${task.successCount}',
                  color: Colors.green,
                ),
                _StatItem(
                  label: '失败',
                  value: '${task.failedCount}',
                  color: Colors.red,
                ),
                _StatItem(
                  label: '重复',
                  value: '${task.duplicateCount}',
                  color: Colors.orange,
                ),
                _StatItem(
                  label: '总计',
                  value: '${task.totalCount}',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            if (task.results.any((r) => !r.success)) ...[
              const Divider(height: 24),
              Text(
                '失败详情',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...task.results
                  .where((r) => !r.success)
                  .take(10)
                  .map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            r.isDuplicate
                                ? Icons.content_copy
                                : Icons.error_outline,
                            size: 14,
                            color: r.isDuplicate ? Colors.orange : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              r.error ?? '未知错误',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
