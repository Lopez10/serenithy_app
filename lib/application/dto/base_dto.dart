import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_dto.freezed.dart';
part 'base_dto.g.dart';

/// DTO base abstracto para transferencia de datos
/// Los DTOs son inmutables y serializables
abstract class BaseDto {
  const BaseDto();

  /// Convierte el DTO a JSON
  Map<String, dynamic> toJson();

  /// Crea una instancia del DTO desde JSON
  /// Debe ser implementado por las clases hijas
}

/// Respuesta API genérica
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    required T data,
    String? message,
    @JsonKey(name: 'error_code') String? errorCode,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

/// Respuesta de error API
@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String message,
    @JsonKey(name: 'error_code') String? errorCode,
    @JsonKey(name: 'status_code') int? statusCode,
    Map<String, dynamic>? details,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

/// DTO para paginación
@freezed
class PaginationDto with _$PaginationDto {
  const factory PaginationDto({
    @Default(1) int page,
    @Default(10) int limit,
    Map<String, dynamic>? filters,
    String? sortBy,
    @Default('asc') String sortOrder,
  }) = _PaginationDto;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}

/// Respuesta paginada
@Freezed(genericArgumentFactories: true)
class PaginatedResponseDto<T> with _$PaginatedResponseDto<T> {
  const factory PaginatedResponseDto({
    required List<T> data,
    required int total,
    required int page,
    required int limit,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'has_next') required bool hasNext,
    @JsonKey(name: 'has_previous') required bool hasPrevious,
  }) = _PaginatedResponseDto<T>;

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginatedResponseDtoFromJson(json, fromJsonT);
}
