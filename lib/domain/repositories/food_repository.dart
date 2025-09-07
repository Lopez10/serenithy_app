import 'package:dartz/dartz.dart';

import '../entities/food.dart';
import '../exceptions/domain_exceptions.dart';
import 'base_repository.dart';

/// Interfaz del repositorio de alimentos
abstract class IFoodRepository extends BaseRepository<Food, String> {
  Future<Either<DomainException, Food>> create(Food food);
}


