import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/name.dart';
import '../../domain/value_objects/password.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import 'base_usecase.dart';

/// Datos de entrada para registrar usuario
class RegisterUserInput {
  const RegisterUserInput({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

/// Caso de uso para registrar un nuevo usuario
@injectable
class RegisterUserUseCase extends BaseUseCase<RegisterUserInput, User> {
  const RegisterUserUseCase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<Either<DomainException, User>> execute(RegisterUserInput input) async {
    try {
      // Crear value objects
      final name = Name(input.name);
      final email = Email(input.email);
      final password = Password(input.password);

      // Verificar si el email ya existe
      final existsResult = await _userRepository.existsByEmail(email);
      
      return existsResult.fold(
        (error) => Left(error),
        (exists) async {
          if (exists) {
            return const Left(
              DomainValidationException('Email already exists'),
            );
          }

          // Crear el usuario
          final user = User.create(
            id: _generateUserId(),
            name: name,
            email: email,
            password: password,
          );

          // Registrar el usuario
          return await _userRepository.register(user);
        },
      );
    } on ValueObjectValidationException catch (e) {
      return Left(DomainValidationException(e.message));
    } catch (e) {
      return Left(DomainException('Registration failed: ${e.toString()}'));
    }
  }

  /// Genera un ID único para el usuario
  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
