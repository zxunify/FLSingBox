import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/singbox/singbox_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _SectionHeader(title: '核心设置'),
          ListTile(
            leading: const Icon(Icons.terminal),
            title: const Text('sing-box 路径'),
            subtitle: const Text('自动检测'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.upgrade),
            title: const Text('核心版本'),
            subtitle: const Text('待检测'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _SectionHeader(title: '代理设置'),
          SwitchListTile(
            secondary: const Icon(Icons.wifi_tethering),
            title: const Text('TUN 模式'),
            subtitle: const Text('需要管理员权限'),
            value: false,
            onChanged: (_) {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.public),
            title: const Text('系统代理'),
            subtitle: const Text('修改系统代理设置'),
            value: true,
            onChanged: (_) {},
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('SOCKS 端口'),
            subtitle: const Text('7890'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('HTTP 端口'),
            subtitle: const Text('7891'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _SectionHeader(title: '通用'),
          SwitchListTile(
            secondary: const Icon(Icons.power_settings_new),
            title: const Text('开机自启动'),
            value: false,
            onChanged: (_) {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.minimize),
            title: const Text('启动时最小化'),
            value: false,
            onChanged: (_) {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('主题模式'),
            subtitle: const Text('跟随系统'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _SectionHeader(title: '高级'),
          ListTile(
            leading: const Icon(Icons.api),
            title: const Text('Clash API'),
            subtitle: const Text('9090'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('日志级别'),
            subtitle: const Text('info'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          _SectionHeader(title: '关于'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('FLSingBox'),
            subtitle: const Text('v0.1.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'FLSingBox',
              applicationVersion: '0.1.0',
              applicationLegalese: '基于 sing-box 的多平台代理客户端',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
