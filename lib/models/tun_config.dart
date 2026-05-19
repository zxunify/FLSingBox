import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TUN 模式配置
class TunConfig {
  final bool enabled;
  final String stack; // system, gvisor, mixed
  final String inet4Address;
  final String inet6Address;
  final int mtu;
  final bool autoRoute;
  final bool strictRoute;
  final bool endpointIndependentNat;
  final List<String> excludePackages; // Android only
  final List<String> includePackages; // Android only

  const TunConfig({
    this.enabled = false,
    this.stack = 'mixed',
    this.inet4Address = '172.19.0.1/30',
    this.inet6Address = 'fdfe:dcba:9876::1/126',
    this.mtu = 9000,
    this.autoRoute = true,
    this.strictRoute = true,
    this.endpointIndependentNat = false,
    this.excludePackages = const [],
    this.includePackages = const [],
  });

  TunConfig copyWith({
    bool? enabled,
    String? stack,
    String? inet4Address,
    String? inet6Address,
    int? mtu,
    bool? autoRoute,
    bool? strictRoute,
    bool? endpointIndependentNat,
    List<String>? excludePackages,
    List<String>? includePackages,
  }) =>
      TunConfig(
        enabled: enabled ?? this.enabled,
        stack: stack ?? this.stack,
        inet4Address: inet4Address ?? this.inet4Address,
        inet6Address: inet6Address ?? this.inet6Address,
        mtu: mtu ?? this.mtu,
        autoRoute: autoRoute ?? this.autoRoute,
        strictRoute: strictRoute ?? this.strictRoute,
        endpointIndependentNat: endpointIndependentNat ?? this.endpointIndependentNat,
        excludePackages: excludePackages ?? this.excludePackages,
        includePackages: includePackages ?? this.includePackages,
      );

  /// 生成 sing-box tun inbound 配置
  Map<String, dynamic> toSingboxInbound() {
    final config = <String, dynamic>{
      'type': 'tun',
      'tag': 'tun-in',
      'inet4_address': inet4Address,
      'inet6_address': inet6Address,
      'mtu': mtu,
      'auto_route': autoRoute,
      'strict_route': strictRoute,
      'endpoint_independent_nat': endpointIndependentNat,
      'stack': stack,
    };

    if (excludePackages.isNotEmpty) {
      config['exclude_package'] = excludePackages;
    }
    if (includePackages.isNotEmpty) {
      config['include_package'] = includePackages;
    }

    return config;
  }
}

/// TUN 配置 Provider
final tunConfigProvider = StateNotifierProvider<TunConfigNotifier, TunConfig>(
  (ref) => TunConfigNotifier(),
);

class TunConfigNotifier extends StateNotifier<TunConfig> {
  TunConfigNotifier() : super(const TunConfig());

  void setEnabled(bool v) => state = state.copyWith(enabled: v);
  void setStack(String v) => state = state.copyWith(stack: v);
  void setInet4Address(String v) => state = state.copyWith(inet4Address: v);
  void setInet6Address(String v) => state = state.copyWith(inet6Address: v);
  void setMtu(int v) => state = state.copyWith(mtu: v);
  void setAutoRoute(bool v) => state = state.copyWith(autoRoute: v);
  void setStrictRoute(bool v) => state = state.copyWith(strictRoute: v);
  void setEndpointIndependentNat(bool v) => state = state.copyWith(endpointIndependentNat: v);

  void addExcludePackage(String pkg) {
    if (!state.excludePackages.contains(pkg)) {
      state = state.copyWith(excludePackages: [...state.excludePackages, pkg]);
    }
  }

  void removeExcludePackage(String pkg) {
    state = state.copyWith(excludePackages: state.excludePackages.where((p) => p != pkg).toList());
  }
}
