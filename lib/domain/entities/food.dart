import 'base_entity.dart';
import '../value_objects/barcode.dart';

/// Entidad Food siguiendo DDD
class Food extends BaseEntity {
  const Food({
    required String id,
    required this.name,
    required this.slug,
    required this.category,
    required this.isProcessed,
    this.barcode,
    this.description,
    this.nutritionalInfo,
    this.scientificName,
    required this.isGeneric,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  final String name;
  final String slug;
  final String category;
  final bool isProcessed;
  final Barcode? barcode;
  final String? description;
  final NutritionalInfo? nutritionalInfo;
  final String? scientificName;
  final bool isGeneric;

  /// Crea un alimento nuevo
  factory Food.create({
    required String id,
    required String name,
    required String slug,
    required String category,
    required bool isProcessed,
    Barcode? barcode,
    String? description,
    NutritionalInfo? nutritionalInfo,
    String? scientificName,
    required bool isGeneric,
  }) {
    final now = DateTime.now();
    return Food(
      id: id,
      name: name,
      slug: slug,
      category: category,
      isProcessed: isProcessed,
      barcode: barcode,
      description: description,
      nutritionalInfo: nutritionalInfo,
      scientificName: scientificName,
      isGeneric: isGeneric,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        category,
        isProcessed,
        barcode,
        description,
        nutritionalInfo,
        scientificName,
        isGeneric,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}

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


