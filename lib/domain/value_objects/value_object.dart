import 'package:equatable/equatable.dart';

/// Value Object base abstracto
/// Los Value Objects son inmutables y se comparan por valor, no por referencia
abstract class ValueObject<T> extends Equatable {
  const ValueObject(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'ValueObject($value)';
}

/// Excepción para errores de validación de Value Objects
class ValueObjectValidationException implements Exception {
  const ValueObjectValidationException(this.message);

  final String message;

  @override
  String toString() => 'ValueObjectValidationException: $message';
}
