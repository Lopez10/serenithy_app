import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/home_shell.dart';
import '../../shared/constants/app_constants.dart';

/// Configuración de rutas de la aplicación
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.register,
    debugLogDiagnostics: true,
    routes: [
      // Ruta de inicio/home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeShell(),
      ),

      // Ruta de registro
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Ruta de login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Ruta de perfil (requiere autenticación)
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Ruta de configuración
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Ruta de información
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
    ],
    
    // Manejo de errores de navegación
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    
    // Redirect para rutas protegidas (implementar cuando tengas auth state)
    // redirect: (context, state) {
    //   final isLoggedIn = // Tu lógica de autenticación
    //   final isLoggingIn = state.subloc == AppRoutes.login || 
    //                      state.subloc == AppRoutes.register;
    //   
    //   if (!isLoggedIn && !isLoggingIn) {
    //     return AppRoutes.login;
    //   }
    //   
    //   if (isLoggedIn && isLoggingIn) {
    //     return AppRoutes.home;
    //   }
    //   
    //   return null;
    // },
  );

  static GoRouter get router => _router;
}

// ==================== PÁGINAS TEMPORALES ====================

/// Página principal temporal
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go(AppRoutes.profile),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a Serenithy!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Aplicación con Arquitectura Hexagonal'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.register),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Página de login temporal
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Página de Login',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.register),
              child: const Text('Ir a Registro'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Ir a Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Página de perfil temporal
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100),
            SizedBox(height: 16),
            Text(
              'Página de Perfil',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// Página de configuración temporal
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 100),
            SizedBox(height: 16),
            Text(
              'Página de Configuración',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// Página de información temporal
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 100),
            SizedBox(height: 16),
            Text(
              'Serenithy v1.0.0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Aplicación con Arquitectura Hexagonal'),
          ],
        ),
      ),
    );
  }
}

/// Página de error
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 100, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Oops! Algo salió mal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
