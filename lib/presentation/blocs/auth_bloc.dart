import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../application/usecases/register_user_usecase.dart';
import '../../application/usecases/login_user_usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import 'base_bloc.dart';

// ==================== EVENTOS ====================

/// Evento para registrar usuario
class RegisterUserEvent extends BaseEvent {
  const RegisterUserEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

/// Evento para hacer login
class LoginUserEvent extends BaseEvent {
  const LoginUserEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Evento para cerrar sesión
class LogoutEvent extends BaseEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para limpiar el estado
class ClearAuthStateEvent extends BaseEvent {
  const ClearAuthStateEvent();

  @override
  List<Object?> get props => [];
}

// ==================== ESTADOS ====================

/// Estado de autenticación no iniciada
class AuthInitialState extends BaseState {
  const AuthInitialState();

  @override
  List<Object?> get props => [];
}

/// Estado de usuario autenticado
class AuthenticatedState extends BaseState {
  const AuthenticatedState(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

/// Estado de usuario no autenticado
class UnauthenticatedState extends BaseState {
  const UnauthenticatedState();

  @override
  List<Object?> get props => [];
}

/// Estado de registro exitoso
class RegistrationSuccessState extends BaseState {
  const RegistrationSuccessState(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

// ==================== BLOC ====================

/// BLoC para manejar la autenticación
@injectable
class AuthBloc extends BaseBloc<BaseEvent, BaseState> {
  AuthBloc(
    this._registerUserUseCase,
    this._loginUserUseCase,
    Logger logger,
  ) : super(const AuthInitialState(), logger: logger) {
    // Registrar manejadores de eventos
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutEvent>(_onLogout);
    on<ClearAuthStateEvent>(_onClearState);
  }

  final RegisterUserUseCase _registerUserUseCase;
  final LoginUserUseCase _loginUserUseCase;

  /// Maneja el evento de registro de usuario
  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const LoadingState(message: 'Registrando usuario...'));

    // Validar confirmación de contraseña
    if (event.password != event.confirmPassword) {
      emit(const ErrorState(
        DomainValidationException('Las contraseñas no coinciden'),
      ));
      return;
    }

    // Ejecutar caso de uso
    final input = RegisterUserInput(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    final result = await _registerUserUseCase.execute(input);

    result.fold(
      (error) => emit(ErrorState(error, message: 'Error en el registro')),
      (user) => emit(RegistrationSuccessState(user)),
    );
  }

  /// Maneja el evento de login de usuario
  Future<void> _onLoginUser(
    LoginUserEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const LoadingState(message: 'Iniciando sesión...'));

    final input = LoginUserInput(
      email: event.email,
      password: event.password,
    );

    final result = await _loginUserUseCase.execute(input);

    result.fold(
      (error) => emit(ErrorState(error, message: 'Error en el login')),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  /// Maneja el evento de logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const LoadingState(message: 'Cerrando sesión...'));
    
    // Aquí podrías limpiar tokens, cache, etc.
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(const UnauthenticatedState());
  }

  /// Maneja el evento de limpiar estado
  Future<void> _onClearState(
    ClearAuthStateEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const AuthInitialState());
  }

  /// Helpers para verificar el estado actual
  bool get isAuthenticated => state is AuthenticatedState;
  bool get isLoading => state is LoadingState;
  bool get hasError => state is ErrorState;
  
  User? get currentUser {
    if (state is AuthenticatedState) {
      return (state as AuthenticatedState).user;
    }
    if (state is RegistrationSuccessState) {
      return (state as RegistrationSuccessState).user;
    }
    return null;
  }
}
