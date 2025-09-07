import '../value_objects/email.dart';
import '../value_objects/name.dart';
import '../value_objects/password.dart';
import 'base_entity.dart';

/// Entidad User del dominio
class User extends BaseEntity {
  const User({
    required String id,
    required this.name,
    required this.email,
    required this.password,
    this.isEmailVerified = false,
    this.profileImageUrl,
    this.lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  final Name name;
  final Email email;
  final Password password;
  final bool isEmailVerified;
  final String? profileImageUrl;
  final DateTime? lastLoginAt;

  /// Crea un nuevo usuario
  factory User.create({
    required String id,
    required Name name,
    required Email email,
    required Password password,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Crea una copia del usuario con campos actualizados
  User copyWith({
    String? id,
    Name? name,
    Email? email,
    Password? password,
    bool? isEmailVerified,
    String? profileImageUrl,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Marca el email como verificado
  User verifyEmail() {
    return copyWith(
      isEmailVerified: true,
      updatedAt: DateTime.now(),
    );
  }

  /// Actualiza la última fecha de login
  User updateLastLogin() {
    return copyWith(
      lastLoginAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Actualiza el perfil del usuario
  User updateProfile({
    Name? name,
    String? profileImageUrl,
  }) {
    return copyWith(
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      updatedAt: DateTime.now(),
    );
  }

  /// Cambia la contraseña del usuario
  User changePassword(Password newPassword) {
    return copyWith(
      password: newPassword,
      updatedAt: DateTime.now(),
    );
  }

  /// Verifica si el usuario está activo
  bool get isActive => !isDeleted;

  /// Verifica si el usuario puede hacer login
  bool get canLogin => isActive && isEmailVerified;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        isEmailVerified,
        profileImageUrl,
        lastLoginAt,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, isEmailVerified: $isEmailVerified)';
  }
}
