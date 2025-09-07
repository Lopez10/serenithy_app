import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:serenithy_app/modules/food/domain/entities/food.dart';
import 'package:serenithy_app/domain/repositories/food_repository.dart';
import 'package:serenithy_app/domain/exceptions/domain_exceptions.dart';
import 'package:serenithy_app/application/usecases/base_usecase.dart';

@injectable
class GetFoodByIdUseCase extends BaseUseCase<String, Food> {
  GetFoodByIdUseCase(this._repository);

  final IFoodRepository _repository;

  @override
  Future<Either<DomainException, Food>> execute(String id) {
    return _repository.findById(id);
  }
}


