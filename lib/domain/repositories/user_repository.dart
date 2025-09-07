import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import '../value_objects/email.dart';
import '../exceptions/domain_exceptions.dart';
import 'base_repository.dart';

/// Interfaz del repositorio de usuarios
abstract class IUserRepository extends BaseRepository<User, String> {
  /// Buscar usuario por email
  Future<Either<DomainException, User?>> findByEmail(Email email);

  /// Registrar un nuevo usuario
  Future<Either<DomainException, User>> register(User user);

  /// Hacer login con email y contraseña
  Future<Either<DomainException, User>> login(
    Email email,
    String password,
  );

  /// Verificar email del usuario
  Future<Either<DomainException, User>> verifyEmail(
    String userId,
    String verificationCode,
  );

  /// Cambiar contraseña del usuario
  Future<Either<DomainException, User>> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
  );

  /// Verificar si existe un usuario con el email dado
  Future<Either<DomainException, bool>> existsByEmail(Email email);

  /// Actualizar perfil del usuario
  Future<Either<DomainException, User>> updateProfile(
    String userId,
    Map<String, dynamic> updates,
  );

  /// Eliminar usuario (soft delete)
  Future<Either<DomainException, void>> softDelete(String userId);

  /// Obtener estadísticas del usuario
  Future<Either<DomainException, Map<String, dynamic>>> getUserStats(
    String userId,
  );
}
