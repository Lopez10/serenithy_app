import 'value_object.dart';

/// Value Object para representar una contraseña válida
class Password extends ValueObject<String> {
  const Password._(String value) : super(value);

  factory Password(String value) {
    if (value.isEmpty) {
      throw const ValueObjectValidationException('Password cannot be empty');
    }

    if (value.length < 8) {
      throw const ValueObjectValidationException(
        'Password must be at least 8 characters long',
      );
    }

    if (value.length > 128) {
      throw const ValueObjectValidationException(
        'Password cannot be longer than 128 characters',
      );
    }

    // Validar que contenga al menos una minúscula
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      throw const ValueObjectValidationException(
        'Password must contain at least one lowercase letter',
      );
    }

    // Validar que contenga al menos una mayúscula
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      throw const ValueObjectValidationException(
        'Password must contain at least one uppercase letter',
      );
    }

    // Validar que contenga al menos un número
    if (!RegExp(r'\d').hasMatch(value)) {
      throw const ValueObjectValidationException(
        'Password must contain at least one number',
      );
    }

    return Password._(value);
  }

  /// Crea una contraseña sin validación (para passwords hasheados)
  const Password.hashed(String hashedValue) : super(hashedValue);

  /// Verifica si la contraseña es fuerte
  bool get isStrong {
    // Contiene al menos un carácter especial
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return false;
    }
    
    // Es lo suficientemente larga
    if (value.length < 12) {
      return false;
    }
    
    return true;
  }

  /// Obtiene la fortaleza de la contraseña (0-100)
  int get strength {
    int score = 0;
    
    // Longitud
    if (value.length >= 8) score += 20;
    if (value.length >= 12) score += 10;
    if (value.length >= 16) score += 10;
    
    // Tipos de caracteres
    if (RegExp(r'[a-z]').hasMatch(value)) score += 15;
    if (RegExp(r'[A-Z]').hasMatch(value)) score += 15;
    if (RegExp(r'\d').hasMatch(value)) score += 15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) score += 15;
    
    return score.clamp(0, 100);
  }
}
