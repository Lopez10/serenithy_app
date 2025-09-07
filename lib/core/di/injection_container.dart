import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../config/app_config.dart';
import '../../infrastructure/adapters/http_client.dart';

import 'injection_container.config.dart';

/// Container de inyección de dependencias
/// Equivalente al sistema de DI de NestJS
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Configuración manual de dependencias core
@module
abstract class CoreModule {
  @singleton
  AppConfig get appConfig => AppConfig.instance;

  @singleton
  Logger get logger => Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @singleton
  Dio get dio {
    final config = getIt<AppConfig>();
    return Dio(
      BaseOptions(
        baseUrl: config.fullApiUrl,
        connectTimeout: Duration(seconds: config.connectTimeout),
        receiveTimeout: Duration(seconds: config.receiveTimeout),
        sendTimeout: Duration(seconds: config.httpTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  @singleton
  HttpClient httpClient(Dio dio, AppConfig config) => 
      HttpClient(dio, config);
}

/// Configuración de dependencias de infraestructura
@module
abstract class InfrastructureModule {
  // Los repositorios se registrarán automáticamente con @Injectable
}

/// Configuración de dependencias de aplicación
@module
abstract class ApplicationModule {
  // Los casos de uso se registrarán automáticamente con @Injectable
}

/// Configuración de dependencias de presentación
@module
abstract class PresentationModule {
  // Los BLoCs se registrarán automáticamente con @Injectable
}
