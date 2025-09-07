import 'package:injectable/injectable.dart';

import '../../application/dto/user_dto.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/name.dart';
import '../../domain/value_objects/password.dart';
import 'base_mapper.dart';

/// Mapper para convertir entre User entidad y DTOs
@injectable
class UserMapper extends BaseMapper<User, UserResponseDto> {
  @override
  User toDomain(UserResponseDto dto) {
    return User(
      id: dto.id,
      name: Name(dto.name),
      email: Email(dto.email),
      password: const Password.hashed(''), // Password hasheado no se envía
      isEmailVerified: dto.isEmailVerified,
      profileImageUrl: dto.profileImageUrl,
      lastLoginAt: dto.lastLoginAt != null 
          ? DateTime.parse(dto.lastLoginAt!)
          : null,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  @override
  UserResponseDto toDto(User domain) {
    return UserResponseDto(
      id: domain.id,
      name: domain.name.value,
      email: domain.email.value,
      isEmailVerified: domain.isEmailVerified,
      profileImageUrl: domain.profileImageUrl,
      lastLoginAt: domain.lastLoginAt?.toIso8601String(),
      createdAt: domain.createdAt?.toIso8601String() ?? 
          DateTime.now().toIso8601String(),
      updatedAt: domain.updatedAt?.toIso8601String() ?? 
          DateTime.now().toIso8601String(),
    );
  }

  /// Convierte RegisterUserDto a User para crear
  User registerDtoToDomain(RegisterUserDto dto, String id) {
    return User.create(
      id: id,
      name: Name(dto.name),
      email: Email(dto.email),
      password: Password(dto.password),
    );
  }

  /// Convierte User a RegisterUserDto (para envío a API)
  RegisterUserDto domainToRegisterDto(User domain) {
    return RegisterUserDto(
      name: domain.name.value,
      email: domain.email.value,
      password: domain.password.value, // Solo en creación
      confirmPassword: domain.password.value,
    );
  }

  /// Convierte LoginUserDto a datos para el repositorio
  Map<String, dynamic> loginDtoToMap(LoginUserDto dto) {
    return {
      'email': dto.email,
      'password': dto.password,
      'remember_me': dto.rememberMe,
    };
  }

  /// Convierte UpdateProfileDto a Map para actualización
  Map<String, dynamic> updateProfileDtoToMap(UpdateProfileDto dto) {
    final map = <String, dynamic>{};
    
    if (dto.name != null) {
      map['name'] = dto.name;
    }
    
    if (dto.profileImageUrl != null) {
      map['profile_image_url'] = dto.profileImageUrl;
    }
    
    return map;
  }

  /// Convierte ChangePasswordDto a Map
  Map<String, dynamic> changePasswordDtoToMap(ChangePasswordDto dto) {
    return {
      'current_password': dto.currentPassword,
      'new_password': dto.newPassword,
      'confirm_password': dto.confirmPassword,
    };
  }

  /// Convierte AuthResponseDto a User
  User authResponseToDomain(AuthResponseDto authResponse) {
    return toDomain(authResponse.user);
  }

  /// Extrae el token de AuthResponseDto
  String extractToken(AuthResponseDto authResponse) {
    return authResponse.accessToken;
  }

  /// Extrae el refresh token de AuthResponseDto
  String? extractRefreshToken(AuthResponseDto authResponse) {
    return authResponse.refreshToken;
  }
}
