import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'pages/home/home_page.dart';
import 'pages/nodes/nodes_page.dart';
import 'pages/nodes/node_edit_page.dart';
import 'pages/import/import_page.dart';
import 'pages/subscriptions/subscriptions_page.dart';
import 'pages/groups/groups_page.dart';
import 'pages/routes/routes_page.dart';
import 'pages/dns/dns_settings_page.dart';
import 'pages/logs/logs_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/chain_proxy/chain_proxy_page.dart';
import 'pages/config_preview/config_preview_page.dart';
import 'pages/tools/tools_page.dart';
import 'pages/connections/connections_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (c, s) => const HomePage()),
        GoRoute(path: '/proxies', builder: (c, s) => const NodesPage()),
        GoRoute(
          path: '/proxies/edit',
          builder: (c, s) => NodeEditPage(nodeId: s.uri.queryParameters['id']),
        ),
        GoRoute(path: '/profiles', builder: (c, s) => const SubscriptionsPage()),
        GoRoute(path: '/import', builder: (c, s) => const ImportPage()),
        GoRoute(path: '/logs', builder: (c, s) => const LogsPage()),
        GoRoute(path: '/connections', builder: (c, s) => const ConnectionsPage()),
        GoRoute(path: '/tools', builder: (c, s) => const ToolsPage()),
        GoRoute(path: '/settings', builder: (c, s) => const SettingsPage()),
        GoRoute(path: '/groups', builder: (c, s) => const GroupsPage()),
        GoRoute(path: '/routes', builder: (c, s) => const RoutesPage()),
        GoRoute(path: '/dns', builder: (c, s) => const DnsSettingsPage()),
        GoRoute(path: '/chain-proxy', builder: (c, s) => const ChainProxyPage()),
        GoRoute(path: '/config-preview', builder: (c, s) => const ConfigPreviewPage()),
        GoRoute(path: '/nodes', builder: (c, s) => const NodesPage()),
        GoRoute(
          path: '/nodes/edit',
          builder: (c, s) => NodeEditPage(nodeId: s.uri.queryParameters['id']),
        ),
        GoRoute(path: '/subscriptions', builder: (c, s) => const SubscriptionsPage()),
      ],
    ),
  ],
);

class FlSingBoxApp extends ConsumerWidget {
  const FlSingBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FLSingBox',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  ThemeData _lightTheme() => ThemeData(
        colorSchemeSeed: const Color(0xFF4A8EF7),
        useMaterial3: true,
        brightness: Brightness.light,
      );

  ThemeData _darkTheme() => ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF4A8EF7),
          secondary: const Color(0xFF64FFDA),
          surface: const Color(0xFF1E1E2E),
          onSurface: Colors.white,
          surfaceContainerHighest: const Color(0xFF2A2A3E),
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        cardTheme: const CardThemeData(
          color: Color(0xFF2A2A3E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2E),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFF16162A),
          indicatorColor: Color(0xFF4A8EF7),
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white54),
        ),
      );
}

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    (icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, route: '/'),
    (icon: Icons.bolt_outlined, activeIcon: Icons.bolt, route: '/proxies'),
    (icon: Icons.folder_outlined, activeIcon: Icons.folder, route: '/profiles'),
    (icon: Icons.article_outlined, activeIcon: Icons.article, route: '/logs'),
    (icon: Icons.hub_outlined, activeIcon: Icons.hub, route: '/connections'),
    (icon: Icons.build_outlined, activeIcon: Icons.build, route: '/tools'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            _buildSideNav(context),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        destinations: _navItems
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.activeIcon),
                label: '',
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSideNav(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      color: theme.navigationRailTheme.backgroundColor ?? const Color(0xFF16162A),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.flash_on,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: IconButton(
                    onPressed: () => _onNavTap(index),
                    icon: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? Colors.white : Colors.white54,
                      size: 22,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(42, 42),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_navItems[index].route);
  }
}
