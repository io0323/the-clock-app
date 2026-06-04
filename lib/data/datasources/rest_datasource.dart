import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/env.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/alarm_config.dart';
import '../../domain/entities/device_shadow.dart';

class RestDataSource {
  RestDataSource() {
    _dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            await _refreshToken();
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          } on Exception {
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  late final Dio _dio;

  Future<DeviceShadow> getShadow(String deviceId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/devices/$deviceId/shadow',
      );
      return DeviceShadow.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to get shadow', code: 'API_GET');
    }
  }

  Future<DeviceShadow> updateShadow(
    String deviceId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/devices/$deviceId/shadow',
        data: data,
      );
      return DeviceShadow.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to update shadow',
          code: 'API_PUT');
    }
  }

  Future<List<AlarmConfig>> getAlarms(String deviceId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/devices/$deviceId/alarms',
      );
      return response.data!
          .map((e) => AlarmConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to get alarms',
          code: 'API_GET');
    }
  }

  Future<AlarmConfig> createAlarm(
    String deviceId,
    AlarmConfig alarm,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/devices/$deviceId/alarms',
        data: alarm.toJson(),
      );
      return AlarmConfig.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Failed to create alarm',
          code: 'API_POST');
    }
  }

  Future<void> _refreshToken() async {
    // TODO: トークンリフレッシュ実装
    debugPrint('Token refresh requested (stub)');
  }
}
