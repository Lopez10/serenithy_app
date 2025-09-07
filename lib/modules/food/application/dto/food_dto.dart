import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_dto.freezed.dart';
part 'food_dto.g.dart';

@freezed
class NutritionalInfoDto with _$NutritionalInfoDto {
  const factory NutritionalInfoDto({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) = _NutritionalInfoDto;

  factory NutritionalInfoDto.fromJson(Map<String, dynamic> json) =>
      _$NutritionalInfoDtoFromJson(json);
}

@freezed
class FoodDto with _$FoodDto {
  const factory FoodDto({
    required String id,
    required String name,
    required String slug,
    required String category,
    @JsonKey(name: 'is_processed') required bool isProcessed,
    String? barcode,
    String? description,
    NutritionalInfoDto? nutritionalInfo,
    @JsonKey(name: 'scientific_name') String? scientificName,
    @JsonKey(name: 'is_generic') required bool isGeneric,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'removed_at') String? removedAt,
  }) = _FoodDto;

  factory FoodDto.fromJson(Map<String, dynamic> json) =>
      _$FoodDtoFromJson(json);
}

@freezed
class CreateFoodDto with _$CreateFoodDto {
  const factory CreateFoodDto({
    required String name,
    required String slug,
    required String category,
    @JsonKey(name: 'is_processed') required bool isProcessed,
    String? barcode,
    String? description,
    NutritionalInfoDto? nutritionalInfo,
    @JsonKey(name: 'scientific_name') String? scientificName,
    @JsonKey(name: 'is_generic') required bool isGeneric,
  }) = _CreateFoodDto;

  factory CreateFoodDto.fromJson(Map<String, dynamic> json) =>
      _$CreateFoodDtoFromJson(json);
}


