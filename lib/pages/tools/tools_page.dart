import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/version_service.dart';

class ToolsPage extends ConsumerWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('工具')),
      body: ListView(
        children: [
          // 更多 section
          _SectionTitle(title: '更多'),
          _ToolItem(
            icon: Icons.storage,
            title: '资源',
            subtitle: '外部资源相关信息',
            onTap: () {},
          ),

          // 设置 section
          _SectionTitle(title: '设置'),
          _ToolItem(
            icon: Icons.language,
            title: '语言',
            subtitle: '默认',
            onTap: () => _showLanguageDialog(context),
          ),
          _ToolItem(
            icon: Icons.palette,
            title: '主题',
            subtitle: '设置深色模式、调整色彩',
            onTap: () => _showThemeDialog(context),
          ),
          _ToolItem(
            icon: Icons.backup,
            title: '备份与恢复',
            subtitle: '通过WebDAV或者文件同步数据',
            onTap: () => _showComingSoon(context),
          ),
          _ToolItem(
            icon: Icons.keyboard,
            title: '快捷键管理',
            subtitle: '使用键盘控制应用程序',
            onTap: () => _showComingSoon(context),
          ),
          _ToolItem(
            icon: Icons.lock_open,
            title: '回环解锁工具',
            subtitle: '用于UWP回环解锁',
            onTap: () => _showComingSoon(context),
          ),
          _ToolItem(
            icon: Icons.edit,
            title: '基本配置',
            subtitle: '全局修改基本配置',
            onTap: () => context.push('/settings'),
          ),
          _ToolItem(
            icon: Icons.tune,
            title: '进阶配置',
            subtitle: '提供多样化配置',
            onTap: () => _showAdvancedConfig(context),
          ),
          _ToolItem(
            icon: Icons.settings_applications,
            title: '应用程序',
            subtitle: '修改应用程序相关设置',
            onTap: () => _showAppSettings(context),
          ),

          // 其他 section
          _SectionTitle(title: '其他'),
          _ToolItem(
            icon: Icons.speaker_notes_off,
            title: '免责声明',
            subtitle: null,
            onTap: () => _showDisclaimer(context),
          ),
          _ToolItem(
            icon: Icons.info_outline,
            title: '关于',
            subtitle: null,
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择语言'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('跟随系统'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('中文'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('English'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('主题设置'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('跟随系统'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('深色模式'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('浅色模式'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedConfig(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('进阶配置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('DNS 设置'),
              leading: const Icon(Icons.dns),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).push('/dns');
              },
            ),
            ListTile(
              title: const Text('路由规则'),
              leading: const Icon(Icons.route),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).push('/routes');
              },
            ),
            ListTile(
              title: const Text('策略组'),
              leading: const Icon(Icons.account_tree),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).push('/groups');
              },
            ),
            ListTile(
              title: const Text('链式代理'),
              leading: const Icon(Icons.link),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).push('/chain-proxy');
              },
            ),
            ListTile(
              title: const Text('配置预览'),
              leading: const Icon(Icons.code),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).push('/config-preview');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showAppSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('应用程序设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('开机自启动'),
              value: false,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('启动时最小化'),
              value: false,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('关闭时最小化到托盘'),
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('功能开发中...')),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('免责声明'),
        content: const Text(
          'FLSingBox 是一个基于 sing-box 的代理客户端工具。\n\n'
          '本软件仅供学习交流使用，请遵守当地法律法规。\n\n'
          '使用本软件所产生的一切后果由使用者自行承担。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    // Use a Consumer to get version info
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final versionAsync = ref.watch(appVersionProvider);
          final version = versionAsync.valueOrNull ?? const AppVersion();
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.flash_on, color: Theme.of(context).colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                const Text('FLSingBox'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutRow(label: '应用版本', value: version.displayVersion),
                _AboutRow(label: 'sing-box 核心', value: version.coreDisplayVersion),
                _AboutRow(label: '发布渠道', value: version.releaseChannel),
                const SizedBox(height: 16),
                const Text('基于 sing-box 的多平台代理客户端'),
                const SizedBox(height: 8),
                Text(
                  '© 2024 FLSingBox',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('确定'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  const _AboutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          )),
        ],
      ),
    );
  }
}
