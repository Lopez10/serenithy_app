import '../../../../domain/value_objects/value_object.dart';

/// Value Object para representar un código de barras (EAN/UPC)
class Barcode extends ValueObject<String> {
  Barcode(String value) : super(_validate(value));

  static String _validate(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) {
      throw const ValueObjectValidationException('Barcode cannot be empty');
    }
    const allowed = [8, 12, 13];
    if (!allowed.contains(cleaned.length)) {
      throw const ValueObjectValidationException(
        'Barcode must be 8, 12 or 13 digits',
      );
    }
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      throw const ValueObjectValidationException('Barcode must contain only digits');
    }
    return cleaned;
  }
}


