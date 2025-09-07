import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/exceptions/domain_exceptions.dart';

// Events
abstract class FoodListEvent extends Equatable {
  const FoodListEvent();
  @override
  List<Object?> get props => [];
}

class LoadFirstPage extends FoodListEvent {
  const LoadFirstPage();
}

class LoadNextPage extends FoodListEvent {
  const LoadNextPage();
}

class RefreshFoods extends FoodListEvent {
  const RefreshFoods();
}

// States
abstract class FoodListState extends Equatable {
  const FoodListState();
  @override
  List<Object?> get props => [];
}

class FoodListInitial extends FoodListState {
  const FoodListInitial();
}

class FoodListLoading extends FoodListState {
  const FoodListLoading();
}

class FoodListLoaded extends FoodListState {
  const FoodListLoaded({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  final List<Food> items;
  final int page;
  final bool hasMore;

  FoodListLoaded copyWith({
    List<Food>? items,
    int? page,
    bool? hasMore,
  }) => FoodListLoaded(
        items: items ?? this.items,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
      );

  @override
  List<Object?> get props => [items, page, hasMore];
}

class FoodListError extends FoodListState {
  const FoodListError(this.error);
  final DomainException error;
  @override
  List<Object?> get props => [error];
}

class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  FoodListBloc(this._repository) : super(const FoodListInitial()) {
    on<LoadFirstPage>(_onLoadFirst);
    on<LoadNextPage>(_onLoadNext);
    on<RefreshFoods>(_onRefresh);
  }

  final IFoodRepository _repository;
  static const int _limit = 10;

  Future<void> _onLoadFirst(
    LoadFirstPage event,
    Emitter<FoodListState> emit,
  ) async {
    emit(const FoodListLoading());
    final result = await _repository.findAll(page: 1, limit: _limit);
    result.fold(
      (e) => emit(FoodListError(e)),
      (items) => emit(FoodListLoaded(
        items: items,
        page: 1,
        hasMore: items.length == _limit,
      )),
    );
  }

  Future<void> _onLoadNext(
    LoadNextPage event,
    Emitter<FoodListState> emit,
  ) async {
    final current = state;
    if (current is! FoodListLoaded || !current.hasMore) return;
    final nextPage = current.page + 1;
    final result = await _repository.findAll(page: nextPage, limit: _limit);
    result.fold(
      (e) => emit(FoodListError(e)),
      (items) => emit(current.copyWith(
        items: [...current.items, ...items],
        page: nextPage,
        hasMore: items.length == _limit,
      )),
    );
  }

  Future<void> _onRefresh(
    RefreshFoods event,
    Emitter<FoodListState> emit,
  ) async {
    add(const LoadFirstPage());
  }
}


