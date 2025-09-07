/// Info nutricional básica
class NutritionalInfo {
  NutritionalInfo({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  }) {
    _validate();
  }

  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;

  void _validate() {
    for (final value in [calories, protein, carbs, fat]) {
      if (value != null && value < 0) {
        throw const FormatException('Nutritional values must be >= 0');
      }
    }
  }
}


