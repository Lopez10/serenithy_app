import 'value_object.dart';

/// Value Object para representar un email válido
class Email extends ValueObject<String> {
  const Email._(String value) : super(value);

  factory Email(String value) {
    if (value.isEmpty) {
      throw const ValueObjectValidationException('Email cannot be empty');
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegExp.hasMatch(value)) {
      throw const ValueObjectValidationException('Invalid email format');
    }

    return Email._(value.toLowerCase().trim());
  }

  String get domain => value.split('@').last;
  String get localPart => value.split('@').first;
}
