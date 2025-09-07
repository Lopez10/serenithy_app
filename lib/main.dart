import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_config.dart';
import 'core/config/app_router.dart';
import 'core/di/injection_container.dart';
import 'shared/constants/app_constants.dart';

/// Función principal de la aplicación
Future<void> main() async {
  // Inicialización básica de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar configuración de entorno
  await AppConfig.load();
  
  // Validar configuración
  AppConfig.instance.validate();

  // Configurar inyección de dependencias
  await configureDependencies();

  // Ejecutar la aplicación
  runApp(const SerenitheApp());
}

/// Aplicación principal
class SerenitheApp extends StatelessWidget {
  const SerenitheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConfig.instance.appName,
          debugShowCheckedModeBanner: AppConfig.instance.isDevelopment,
          theme: _buildTheme(),
          routerConfig: AppRouter.router,
        );
      },
    );
  }

  /// Construye el tema de la aplicación
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Inter',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
      ),
    );
  }
}

