import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import '../usecases/base_usecase.dart';

@injectable
class GetFoodByIdUseCase extends BaseUseCase<String, Food?> {
  GetFoodByIdUseCase(this._repository);

  final IFoodRepository _repository;

  @override
  Future<Either<DomainException, Food?>> execute(String id) {
    return _repository.findById(id);
  }
}


