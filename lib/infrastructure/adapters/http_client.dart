import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import '../../core/config/app_config.dart';

/// Cliente HTTP configurado para comunicación con la API
class HttpClient {
  HttpClient(this._dio, this._appConfig) {
    _setupInterceptors();
  }

  final Dio _dio;
  final AppConfig _appConfig;

  void _setupInterceptors() {
    // Interceptor para agregar token de autorización
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _appConfig.authToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          final domainError = _mapDioErrorToDomainException(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: domainError,
            ),
          );
        },
      ),
    );

    // Interceptor de logging en desarrollo
    if (_appConfig.isDevelopment) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ));
    }
  }

  /// GET request genérico
  Future<Either<DomainException, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      return Right(fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_mapDioErrorToDomainException(e));
    }
  }

  /// POST request genérico
  Future<Either<DomainException, T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return Right(fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_mapDioErrorToDomainException(e));
    }
  }

  /// PUT request genérico
  Future<Either<DomainException, T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return Right(fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_mapDioErrorToDomainException(e));
    }
  }

  /// DELETE request genérico
  Future<Either<DomainException, void>> delete(String path) async {
    try {
      await _dio.delete(path);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioErrorToDomainException(e));
    }
  }

  /// Mapea errores de Dio a excepciones del dominio
  DomainException _mapDioErrorToDomainException(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return DomainValidationException(
          error.response?.data['message'] ?? 'Bad request',
        );
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return EntityNotFoundException(
          'Resource',
          error.requestOptions.path,
        );
      case 500:
      default:
        return DomainValidationException(
          error.response?.data['message'] ?? 'Network error',
        );
    }
  }
}
