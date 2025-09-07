import 'value_object.dart';

/// Value Object para representar un nombre válido
class Name extends ValueObject<String> {
  const Name._(String value) : super(value);

  factory Name(String value) {
    if (value.isEmpty) {
      throw const ValueObjectValidationException('Name cannot be empty');
    }

    if (value.length < 2) {
      throw const ValueObjectValidationException(
        'Name must be at least 2 characters long',
      );
    }

    if (value.length > 50) {
      throw const ValueObjectValidationException(
        'Name cannot be longer than 50 characters',
      );
    }

    // Validar que solo contenga letras y espacios
    final nameRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      throw const ValueObjectValidationException(
        'Name can only contain letters and spaces',
      );
    }

    return Name._(value.trim());
  }

  String get firstName {
    final parts = value.split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  String get lastName {
    final parts = value.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  String get initials {
    final parts = value.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
