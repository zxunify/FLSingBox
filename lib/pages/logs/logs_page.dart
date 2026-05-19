import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/singbox/singbox_controller.dart';

class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> {
  final _logs = <String>[];
  final _scrollCtrl = ScrollController();
  StreamSubscription? _sub;
  String _filter = '';
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    final ctrl = ref.read(singBoxControllerProvider.notifier);
    _sub = ctrl.logStream.listen((line) {
      setState(() => _logs.add(line));
      if (_autoScroll && _scrollCtrl.hasClients) {
        Future.microtask(() => _scrollCtrl.animateTo(
              _scrollCtrl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isEmpty
        ? _logs
        : _logs.where((l) => l.toLowerCase().contains(_filter.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('运行日志'),
        actions: [
          IconButton(
            icon: Icon(_autoScroll ? Icons.vertical_align_bottom : Icons.pause),
            onPressed: () => setState(() => _autoScroll = !_autoScroll),
            tooltip: _autoScroll ? '自动滚动' : '暂停滚动',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _logs.clear()),
            tooltip: '清空',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (v) => setState(() => _filter = v),
              decoration: InputDecoration(
                hintText: '过滤日志...',
                prefixIcon: const Icon(Icons.filter_list),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('暂无日志'))
                : ListView.builder(
                    controller: _scrollCtrl,
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _LogLine(text: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }
}

class _LogLine extends StatelessWidget {
  final String text;
  const _LogLine({required this.text});

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (text.contains('error') || text.contains('STDERR')) {
      color = Colors.red;
    } else if (text.contains('warn')) {
      color = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
