import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:serenithy_app/modules/food/domain/entities/food.dart';
import 'package:serenithy_app/modules/food/domain/value_objects/barcode.dart';
import 'package:serenithy_app/domain/repositories/food_repository.dart';
import 'package:serenithy_app/domain/exceptions/domain_exceptions.dart';
import 'package:serenithy_app/application/usecases/base_usecase.dart';

class CreateFoodInput {
  const CreateFoodInput({
    required this.name,
    required this.slug,
    required this.category,
    required this.isProcessed,
    this.barcode,
    this.description,
    this.nutritionalInfo,
    this.scientificName,
    required this.isGeneric,
  });

  final String name;
  final String slug;
  final String category;
  final bool isProcessed;
  final String? barcode;
  final NutritionalInfo? nutritionalInfo;
  final String? description;
  final String? scientificName;
  final bool isGeneric;
}

@injectable
class CreateFoodUseCase extends BaseUseCase<CreateFoodInput, Food> {
  CreateFoodUseCase(this._repository);

  final IFoodRepository _repository;

  @override
  Future<Either<DomainException, Food>> execute(CreateFoodInput input) async {
    try {
      final food = Food.create(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: input.name,
        slug: input.slug,
        category: input.category,
        isProcessed: input.isProcessed,
        barcode: input.barcode != null ? Barcode(input.barcode!) : null,
        description: input.description,
        nutritionalInfo: input.nutritionalInfo,
        scientificName: input.scientificName,
        isGeneric: input.isGeneric,
      );

      return _repository.create(food);
    } catch (e) {
      return Left(BusinessRuleException('Create food failed: ${e.toString()}'));
    }
  }
}


