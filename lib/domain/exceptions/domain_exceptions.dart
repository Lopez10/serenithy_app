/// Excepción base del dominio
abstract class DomainException implements Exception {
  const DomainException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Excepción cuando una entidad no se encuentra
class EntityNotFoundException extends DomainException {
  const EntityNotFoundException(String entityType, String id)
      : super('$entityType with id $id not found');
}

/// Excepción de validación del dominio
class DomainValidationException extends DomainException {
  const DomainValidationException(String message) : super(message);
}

/// Excepción de regla de negocio
class BusinessRuleException extends DomainException {
  const BusinessRuleException(String message) : super(message);
}

/// Excepción de autorización
class UnauthorizedException extends DomainException {
  const UnauthorizedException([String message = 'Unauthorized access'])
      : super(message);
}

/// Excepción de recurso prohibido
class ForbiddenException extends DomainException {
  const ForbiddenException([String message = 'Access forbidden'])
      : super(message);
}
