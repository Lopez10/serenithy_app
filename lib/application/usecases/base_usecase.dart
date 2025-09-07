import 'package:dartz/dartz.dart';
import '../../domain/exceptions/domain_exceptions.dart';

/// Caso de uso base abstracto que define la interfaz común
/// Sigue el principio de responsabilidad única
abstract class BaseUseCase<Input, Output> {
  /// Ejecuta el caso de uso con los parámetros de entrada
  /// Retorna Either para manejo funcional de errores
  Future<Either<DomainException, Output>> execute(Input input);
}

/// Caso de uso sin parámetros de entrada
abstract class NoInputUseCase<Output> {
  Future<Either<DomainException, Output>> execute();
}

/// Caso de uso sin retorno (void)
abstract class VoidUseCase<Input> {
  Future<Either<DomainException, void>> execute(Input input);
}

/// Caso de uso sin entrada ni retorno
abstract class NoInputVoidUseCase {
  Future<Either<DomainException, void>> execute();
}
