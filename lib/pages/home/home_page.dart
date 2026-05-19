import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/singbox/singbox_controller.dart';
import '../../providers/app_providers.dart';
import '../../services/network_detection_service.dart';
import '../../services/traffic_monitor_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('仪表盘'),
        actions: [
          // Connection status indicator
          _ConnectionIndicator(ref: ref),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
            tooltip: '编辑布局',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return _buildWideLayout(context, ref, theme);
          }
          return _buildNarrowLayout(context, ref, theme);
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                // Left: Network speed chart
                Expanded(
                  flex: 3,
                  child: _NetworkSpeedCard(ref: ref),
                ),
                const SizedBox(width: 12),
                // Right: System proxy + TUN
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(child: _SystemProxyCard(ref: ref)),
                      const SizedBox(height: 12),
                      Expanded(child: _TunCard(ref: ref)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                // Outbound mode
                Expanded(flex: 2, child: _OutboundModeCard(ref: ref)),
                const SizedBox(width: 12),
                // Network detection
                Expanded(flex: 2, child: _NetworkDetectionCard(ref: ref)),
                const SizedBox(width: 12),
                // Traffic stats
                Expanded(flex: 2, child: _TrafficStatsCard(ref: ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, WidgetRef ref, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(height: 200, child: _NetworkSpeedCard(ref: ref)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: SizedBox(height: 110, child: _SystemProxyCard(ref: ref))),
            const SizedBox(width: 12),
            Expanded(child: SizedBox(height: 110, child: _TunCard(ref: ref))),
          ],
        ),
        const SizedBox(height: 12),
        _OutboundModeCard(ref: ref),
        const SizedBox(height: 12),
        SizedBox(height: 160, child: _NetworkDetectionCard(ref: ref)),
        const SizedBox(height: 12),
        SizedBox(height: 180, child: _TrafficStatsCard(ref: ref)),
      ],
    );
  }
}

class _ConnectionIndicator extends StatelessWidget {
  final WidgetRef ref;
  const _ConnectionIndicator({required this.ref});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(singBoxControllerProvider);
    final isRunning = state.status == SingBoxStatus.running;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRunning ? Colors.green : Colors.grey,
      ),
      child: Icon(
        isRunning ? Icons.check : Icons.remove,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}

// ===== Network Speed Card =====
class _NetworkSpeedCard extends StatelessWidget {
  final WidgetRef ref;
  const _NetworkSpeedCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    final traffic = ref.watch(trafficMonitorProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('网络速度', style: theme.textTheme.titleSmall),
                const Spacer(),
                Text(
                  '↑ ${formatSpeed(traffic.uploadSpeed)}  ↓ ${formatSpeed(traffic.downloadSpeed)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Speed chart area
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: _SpeedChartPainter(
                  history: traffic.speedHistory,
                  theme: theme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedChartPainter extends CustomPainter {
  final List<SpeedPoint> history;
  final ThemeData theme;

  _SpeedChartPainter({required this.history, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) {
      // Draw baseline
      final paint = Paint()
        ..color = theme.colorScheme.outlineVariant
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(0, size.height - 1),
        Offset(size.width, size.height - 1),
        paint,
      );
      return;
    }

    final maxSpeed = history.fold<int>(
      1,
      (max, p) => p.download > max ? p.download : (p.upload > max ? p.upload : max),
    );

    // Draw download line
    _drawLine(canvas, size, maxSpeed, (p) => p.download, theme.colorScheme.primary);
    // Draw upload line
    _drawLine(canvas, size, maxSpeed, (p) => p.upload, theme.colorScheme.secondary);
  }

  void _drawLine(Canvas canvas, Size size, int maxSpeed, int Function(SpeedPoint) getValue, Color color) {
    if (history.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < history.length; i++) {
      final x = (i / (history.length - 1)) * size.width;
      final y = size.height - (getValue(history[i]) / maxSpeed) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SpeedChartPainter oldDelegate) =>
      oldDelegate.history.length != history.length;
}

// ===== System Proxy Card =====
class _SystemProxyCard extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _SystemProxyCard({required this.ref});

  @override
  ConsumerState<_SystemProxyCard> createState() => _SystemProxyCardState();
}

class _SystemProxyCardState extends ConsumerState<_SystemProxyCard> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.public, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text('系统代理', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    '选项',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== TUN Card =====
class _TunCard extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _TunCard({required this.ref});

  @override
  ConsumerState<_TunCard> createState() => _TunCardState();
}

class _TunCardState extends ConsumerState<_TunCard> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.settings_ethernet, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text('虚拟网卡', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    '选项',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Outbound Mode Card =====
class _OutboundModeCard extends ConsumerWidget {
  final WidgetRef ref;
  const _OutboundModeCard({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(proxyModeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cell_tower, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('出站模式', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            _ModeRadio(
              label: '规则',
              isSelected: mode == ProxyMode.rule,
              onTap: () => ref.read(proxyModeProvider.notifier).state = ProxyMode.rule,
            ),
            _ModeRadio(
              label: '全局',
              isSelected: mode == ProxyMode.global,
              onTap: () => ref.read(proxyModeProvider.notifier).state = ProxyMode.global,
            ),
            _ModeRadio(
              label: '直连',
              isSelected: mode == ProxyMode.direct,
              onTap: () => ref.read(proxyModeProvider.notifier).state = ProxyMode.direct,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeRadio extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeRadio({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (_) => onTap(),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// ===== Network Detection Card =====
class _NetworkDetectionCard extends ConsumerWidget {
  final WidgetRef ref;
  const _NetworkDetectionCard({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final netInfo = ref.watch(networkDetectionProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.travel_explore, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('网络检测', style: theme.textTheme.titleSmall),
                const Spacer(),
                if (netInfo.isLoading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  InkWell(
                    onTap: () => ref.read(networkDetectionProvider.notifier).detect(),
                    child: const Icon(Icons.info_outline, size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // External IP
            Row(
              children: [
                _CountryFlag(countryCode: netInfo.countryCode),
                const SizedBox(width: 8),
                Text(
                  netInfo.externalIp ?? '检测中...',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Internal IP
            Row(
              children: [
                Icon(Icons.computer, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('内网 IP', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              netInfo.internalIp ?? '获取中...',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String? countryCode;
  const _CountryFlag({this.countryCode});

  @override
  Widget build(BuildContext context) {
    if (countryCode == null) {
      return const Icon(Icons.flag, size: 18);
    }
    // Convert country code to emoji flag
    final flag = countryCode!.toUpperCase().codeUnits.map(
      (c) => String.fromCharCode(c + 0x1F1A5),
    ).join();
    return Text(flag, style: const TextStyle(fontSize: 16));
  }
}

// ===== Traffic Stats Card =====
class _TrafficStatsCard extends ConsumerWidget {
  final WidgetRef ref;
  const _TrafficStatsCard({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final traffic = ref.watch(trafficMonitorProvider);
    final total = traffic.uploadTotal + traffic.downloadTotal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.data_usage, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('流量统计', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                children: [
                  // Donut chart
                  Expanded(
                    child: CustomPaint(
                      painter: _DonutChartPainter(
                        uploadRatio: total > 0
                            ? traffic.uploadTotal / total
                            : 0.5,
                        theme: theme,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Legend
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        color: theme.colorScheme.onSurface,
                        label: '上传',
                      ),
                      _LegendItem(
                        color: theme.colorScheme.onSurfaceVariant,
                        label: '下载',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 12),
                          const SizedBox(width: 4),
                          Text(formatBytes(traffic.uploadTotal),
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.arrow_downward, size: 12),
                          const SizedBox(width: 4),
                          Text(formatBytes(traffic.downloadTotal),
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double uploadRatio;
  final ThemeData theme;

  _DonutChartPainter({required this.uploadRatio, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 8;
    final strokeWidth = radius * 0.3;

    // Background ring
    final bgPaint = Paint()
      ..color = theme.colorScheme.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Upload arc
    final uploadPaint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final uploadSweep = uploadRatio * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      uploadSweep,
      false,
      uploadPaint,
    );

    // Download arc
    final downloadPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2 + uploadSweep,
      (1 - uploadRatio) * 2 * 3.14159,
      false,
      downloadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.uploadRatio != uploadRatio;
}
