import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:serenithy_app/domain/repositories/food_repository.dart';
import 'package:serenithy_app/modules/food/domain/entities/food.dart';
import 'package:serenithy_app/modules/food/application/dto/food_dto.dart';
import 'package:serenithy_app/modules/food/infrastructure/mappers/food_mapper.dart';
import 'package:serenithy_app/infrastructure/adapters/http_client.dart';
import 'package:serenithy_app/shared/constants/app_constants.dart';
import 'package:serenithy_app/domain/exceptions/domain_exceptions.dart';

@LazySingleton(as: IFoodRepository)
class FoodRepositoryImpl implements IFoodRepository {
  FoodRepositoryImpl(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<Either<DomainException, Food>> create(Food food) async {
    final dto = FoodMapper.toCreateDto(food).toJson();
    final result = await _httpClient.post<FoodDto>(
      ApiConstants.foodsEndpoint,
      data: dto,
      fromJson: (json) => FoodDto.fromJson(json),
    );
    return result.map(FoodMapper.fromDto);
  }

  @override
  Future<Either<DomainException, Food>> findById(String id) async {
    final result = await _httpClient.get<FoodDto>(
      '${ApiConstants.foodsEndpoint}/$id',
      fromJson: (json) => FoodDto.fromJson(json),
    );
    return result.map(FoodMapper.fromDto);
  }

  @override
  Future<Either<DomainException, List<Food>>> findAll({
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    final result = await _httpClient.get<Map<String, dynamic>>(
      ApiConstants.foodsEndpoint,
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        ...?filters,
      },
      fromJson: (json) => json,
    );

    return result.fold(
      (l) => Left(l),
      (json) {
        final list = (json['data'] ?? json) as dynamic;
        final items = (list as List)
            .map((e) => FoodMapper.fromDto(FoodDto.fromJson(e as Map<String, dynamic>)))
            .toList();
        return Right(items);
      },
    );
  }

  @override
  Future<Either<DomainException, Food>> update(String id, Food entity) async {
    final dto = FoodMapper.toCreateDto(entity).toJson();
    final result = await _httpClient.put<FoodDto>(
      '${ApiConstants.foodsEndpoint}/$id',
      data: dto,
      fromJson: (json) => FoodDto.fromJson(json),
    );
    return result.map(FoodMapper.fromDto);
  }

  @override
  Future<Either<DomainException, void>> delete(String id) async {
    return _httpClient.delete('${ApiConstants.foodsEndpoint}/$id');
  }

  @override
  Future<Either<DomainException, bool>> exists(String id) async {
    final result = await _httpClient.get<Map<String, dynamic>>(
      '${ApiConstants.foodsEndpoint}/$id/exists',
      fromJson: (json) => json,
    );
    return result.map((json) => (json['exists'] as bool?) ?? true);
  }
}


