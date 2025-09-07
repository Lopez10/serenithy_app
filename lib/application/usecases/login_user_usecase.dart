import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/value_object.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import 'base_usecase.dart';

/// Datos de entrada para login de usuario
class LoginUserInput {
  const LoginUserInput({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

/// Caso de uso para hacer login de usuario
@injectable
class LoginUserUseCase extends BaseUseCase<LoginUserInput, User> {
  LoginUserUseCase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<Either<DomainException, User>> execute(LoginUserInput input) async {
    try {
      // Crear value object para email
      final email = Email(input.email);

      // Validar que la contraseña no esté vacía
      if (input.password.isEmpty) {
        return const Left(
          DomainValidationException('Password cannot be empty'),
        );
      }

      // Intentar hacer login
      final result = await _userRepository.login(email, input.password);

      return result.fold(
        (error) => Left(error),
        (user) {
          // Verificar que el usuario pueda hacer login
          if (!user.canLogin) {
            if (!user.isActive) {
              return const Left(
                UnauthorizedException('Account is deactivated'),
              );
            }
            if (!user.isEmailVerified) {
              return const Left(
                UnauthorizedException('Email not verified'),
              );
            }
          }

          return Right(user);
        },
      );
    } on ValueObjectValidationException catch (e) {
      return Left(DomainValidationException(e.message));
    } catch (e) {
      return Left(BusinessRuleException('Login failed: ${e.toString()}'));
    }
  }
}
