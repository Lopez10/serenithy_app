import 'package:serenithy_app/modules/food/domain/entities/food.dart';
import 'package:serenithy_app/modules/food/domain/value_objects/barcode.dart';
import 'package:serenithy_app/modules/food/application/dto/food_dto.dart';

class FoodMapper {
  static Food fromDto(FoodDto dto) {
    return Food(
      id: dto.id,
      name: dto.name,
      slug: dto.slug,
      category: dto.category,
      isProcessed: dto.isProcessed,
      barcode: dto.barcode != null ? Barcode(dto.barcode!) : null,
      description: dto.description,
      nutritionalInfo: dto.nutritionalInfo != null
          ? NutritionalInfo(
              calories: dto.nutritionalInfo!.calories,
              protein: dto.nutritionalInfo!.protein,
              carbs: dto.nutritionalInfo!.carbs,
              fat: dto.nutritionalInfo!.fat,
            )
          : null,
      scientificName: dto.scientificName,
      isGeneric: dto.isGeneric,
      createdAt: dto.createdAt != null ? DateTime.parse(dto.createdAt!) : null,
      updatedAt: dto.updatedAt != null ? DateTime.parse(dto.updatedAt!) : null,
      deletedAt: dto.removedAt != null ? DateTime.parse(dto.removedAt!) : null,
    );
  }

  static CreateFoodDto toCreateDto(Food food) {
    return CreateFoodDto(
      name: food.name,
      slug: food.slug,
      category: food.category,
      isProcessed: food.isProcessed,
      barcode: food.barcode?.value,
      description: food.description,
      nutritionalInfo: food.nutritionalInfo != null
          ? NutritionalInfoDto(
              calories: food.nutritionalInfo!.calories,
              protein: food.nutritionalInfo!.protein,
              carbs: food.nutritionalInfo!.carbs,
              fat: food.nutritionalInfo!.fat,
            )
          : null,
      scientificName: food.scientificName,
      isGeneric: food.isGeneric,
    );
  }
}


