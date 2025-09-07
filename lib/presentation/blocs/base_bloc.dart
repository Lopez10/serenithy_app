import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../domain/exceptions/domain_exceptions.dart';

/// Estado base para todos los BLoCs
abstract class BaseState extends Equatable {
  const BaseState();
}

/// Estado inicial
class InitialState extends BaseState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

/// Estado de cargando
class LoadingState extends BaseState {
  const LoadingState({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Estado de éxito con datos
class SuccessState<T> extends BaseState {
  const SuccessState(this.data, {this.message});

  final T data;
  final String? message;

  @override
  List<Object?> get props => [data, message];
}

/// Estado de error
class ErrorState extends BaseState {
  const ErrorState(this.error, {this.message});

  final DomainException error;
  final String? message;

  @override
  List<Object?> get props => [error, message];
}

/// Evento base para todos los BLoCs
abstract class BaseEvent extends Equatable {
  const BaseEvent();
}

/// BLoC base abstracto con funcionalidades comunes
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(State initialState, {Logger? logger})
      : _logger = logger,
        super(initialState);

  final Logger? _logger;

  /// Logs información del evento
  void logEvent(Event event) {
    _logger?.i('Event: ${event.runtimeType}');
  }

  /// Logs información del estado
  void logState(State state) {
    _logger?.i('State: ${state.runtimeType}');
  }

  /// Emite un estado de cargando
  void emitLoading({String? message}) {
    emit(LoadingState(message: message) as State);
  }

  /// Emite un estado de éxito
  void emitSuccess<T>(T data, {String? message}) {
    emit(SuccessState<T>(data, message: message) as State);
  }

  /// Emite un estado de error
  void emitError(DomainException error, {String? message}) {
    emit(ErrorState(error, message: message) as State);
  }

  /// Maneja el resultado de un Either de manera estandarizada
  void handleEither<T>(
    Either<DomainException, T> either, {
    required void Function(T data) onSuccess,
    void Function(DomainException error)? onError,
  }) {
    either.fold(
      (error) {
        _logger?.e('Error: $error');
        if (onError != null) {
          onError(error);
        } else {
          emitError(error);
        }
      },
      (data) {
        _logger?.d('Success: ${data.runtimeType}');
        onSuccess(data);
      },
    );
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    logState(change.nextState);
  }

  @override
  void onEvent(Event event) {
    super.onEvent(event);
    logEvent(event);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    _logger?.e('BLoC Error', error: error, stackTrace: stackTrace);
  }
}
