import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración type-safe de la aplicación
/// Equivalente al ConfigService de NestJS
class AppConfig {
  const AppConfig._();

  static const AppConfig _instance = AppConfig._();
  static AppConfig get instance => _instance;

  /// Cargar configuración desde .env
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // API Configuration
  String get apiBaseUrl => 
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  String get fullApiUrl => '$apiBaseUrl/api/$apiVersion';

  // Environment
  String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  bool get isDevelopment => environment == 'development';
  bool get isProduction => environment == 'production';
  bool get isStaging => environment == 'staging';

  // Auth Configuration
  String? get authToken => dotenv.env['AUTH_TOKEN'];

  String get jwtSecret => dotenv.env['JWT_SECRET'] ?? 'default-secret';

  // Database/Storage Configuration
  String get databaseName => dotenv.env['DATABASE_NAME'] ?? 'serenithy_app';

  // Feature Flags
  bool get enableAnalytics => 
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  bool get enableCrashReporting => 
      dotenv.env['ENABLE_CRASH_REPORTING']?.toLowerCase() == 'true';

  bool get enableLogging => 
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true' || isDevelopment;

  // App Configuration
  String get appName => dotenv.env['APP_NAME'] ?? 'Serenithy';

  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  // Network Configuration
  int get httpTimeout => 
      int.tryParse(dotenv.env['HTTP_TIMEOUT'] ?? '30') ?? 30;

  int get connectTimeout => 
      int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '30') ?? 30;

  int get receiveTimeout => 
      int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30') ?? 30;

  // Cache Configuration
  int get cacheMaxAge => 
      int.tryParse(dotenv.env['CACHE_MAX_AGE'] ?? '3600') ?? 3600;

  // Validation
  void validate() {
    if (apiBaseUrl.isEmpty) {
      throw Exception('API_BASE_URL is required');
    }

    if (jwtSecret.isEmpty && !isDevelopment) {
      throw Exception('JWT_SECRET is required in production');
    }

    if (httpTimeout <= 0) {
      throw Exception('HTTP_TIMEOUT must be greater than 0');
    }
  }

  // Debug Information
  Map<String, dynamic> toJson() => {
    'apiBaseUrl': apiBaseUrl,
    'apiVersion': apiVersion,
    'environment': environment,
    'appName': appName,
    'appVersion': appVersion,
    'httpTimeout': httpTimeout,
    'enableAnalytics': enableAnalytics,
    'enableCrashReporting': enableCrashReporting,
    'enableLogging': enableLogging,
  };

  @override
  String toString() => 'AppConfig(${toJson()})';
}
