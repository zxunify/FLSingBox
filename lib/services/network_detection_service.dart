import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkInfo {
  final String? externalIp;
  final String? country;
  final String? countryCode;
  final String? internalIp;
  final bool isLoading;
  final String? error;

  const NetworkInfo({
    this.externalIp,
    this.country,
    this.countryCode,
    this.internalIp,
    this.isLoading = false,
    this.error,
  });

  NetworkInfo copyWith({
    String? externalIp,
    String? country,
    String? countryCode,
    String? internalIp,
    bool? isLoading,
    String? error,
  }) {
    return NetworkInfo(
      externalIp: externalIp ?? this.externalIp,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      internalIp: internalIp ?? this.internalIp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NetworkDetectionNotifier extends StateNotifier<NetworkInfo> {
  final Dio _dio;

  NetworkDetectionNotifier()
      : _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5))),
        super(const NetworkInfo()) {
    detect();
  }

  Future<void> detect() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Get external IP
      final response = await _dio.get('https://api.ip.sb/geoip');
      if (response.statusCode == 200) {
        final data = response.data;
        state = state.copyWith(
          externalIp: data['ip'] as String?,
          country: data['country'] as String?,
          countryCode: data['country_code'] as String?,
          isLoading: false,
        );
      }
    } catch (e) {
      // Fallback to simple ip.sb
      try {
        final response = await _dio.get('https://api.ip.sb/ip');
        if (response.statusCode == 200) {
          state = state.copyWith(
            externalIp: response.data.toString().trim(),
            isLoading: false,
          );
        }
      } catch (_) {
        state = state.copyWith(isLoading: false, error: '检测失败');
      }
    }

    // Get internal IP
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback) {
            state = state.copyWith(internalIp: addr.address);
            return;
          }
        }
      }
    } catch (_) {}
  }
}

final networkDetectionProvider =
    StateNotifierProvider<NetworkDetectionNotifier, NetworkInfo>(
  (ref) => NetworkDetectionNotifier(),
);
