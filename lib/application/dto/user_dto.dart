import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'base_dto.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// DTO para registrar un usuario
@freezed
class RegisterUserDto with _$RegisterUserDto {
  const factory RegisterUserDto({
    required String name,
    required String email,
    required String password,
    @JsonKey(name: 'confirm_password') required String confirmPassword,
  }) = _RegisterUserDto;

  factory RegisterUserDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserDtoFromJson(json);
}

/// DTO para login de usuario
@freezed
class LoginUserDto with _$LoginUserDto {
  const factory LoginUserDto({
    required String email,
    required String password,
    @Default(false) @JsonKey(name: 'remember_me') bool rememberMe,
  }) = _LoginUserDto;

  factory LoginUserDto.fromJson(Map<String, dynamic> json) =>
      _$LoginUserDtoFromJson(json);
}

/// DTO de respuesta de usuario
@freezed
class UserResponseDto with _$UserResponseDto {
  const factory UserResponseDto({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'is_email_verified') required bool isEmailVerified,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _UserResponseDto;

  factory UserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserResponseDtoFromJson(json);
}

/// DTO de respuesta de autenticación
@freezed
class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required UserResponseDto user,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}

/// DTO para actualizar perfil
@freezed
class UpdateProfileDto with _$UpdateProfileDto {
  const factory UpdateProfileDto({
    String? name,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _UpdateProfileDto;

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
}

/// DTO para cambiar contraseña
@freezed
class ChangePasswordDto with _$ChangePasswordDto {
  const factory ChangePasswordDto({
    @JsonKey(name: 'current_password') required String currentPassword,
    @JsonKey(name: 'new_password') required String newPassword,
    @JsonKey(name: 'confirm_password') required String confirmPassword,
  }) = _ChangePasswordDto;

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDtoFromJson(json);
}

/// DTO para verificar email
@freezed
class VerifyEmailDto with _$VerifyEmailDto {
  const factory VerifyEmailDto({
    @JsonKey(name: 'verification_code') required String verificationCode,
  }) = _VerifyEmailDto;

  factory VerifyEmailDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailDtoFromJson(json);
}

/// DTO para solicitar restablecimiento de contraseña
@freezed
class ForgotPasswordDto with _$ForgotPasswordDto {
  const factory ForgotPasswordDto({
    required String email,
  }) = _ForgotPasswordDto;

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoFromJson(json);
}

/// DTO para restablecer contraseña
@freezed
class ResetPasswordDto with _$ResetPasswordDto {
  const factory ResetPasswordDto({
    required String token,
    @JsonKey(name: 'new_password') required String newPassword,
    @JsonKey(name: 'confirm_password') required String confirmPassword,
  }) = _ResetPasswordDto;

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDtoFromJson(json);
}
