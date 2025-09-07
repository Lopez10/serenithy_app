# Serenithy Flutter App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.13.0+-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.1.0+-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Aplicación móvil Flutter para Serenithy que implementa **Arquitectura Hexagonal (Clean Architecture)** siguiendo los principios de **Domain-Driven Design (DDD)**.

## 🏗️ Arquitectura

Este proyecto sigue una arquitectura hexagonal estricta, similar a la implementada en el backend NestJS:

```
lib/
├── core/                    # Núcleo de la aplicación
│   ├── config/             # Configuración type-safe
│   ├── di/                 # Inyección de dependencias
│   ├── errors/             # Manejo de errores global
│   └── utils/              # Utilidades compartidas
├── domain/                  # Capa de Dominio (Business Logic)
│   ├── entities/           # Entidades del dominio
│   ├── value_objects/      # Value Objects
│   ├── repositories/       # Contratos de repositorios
│   └── exceptions/         # Excepciones del dominio
├── application/             # Capa de Aplicación (Use Cases)
│   ├── dto/                # DTOs de aplicación
│   └── usecases/           # Casos de uso
├── infrastructure/          # Capa de Infraestructura (External Concerns)
│   ├── adapters/           # Adaptadores (HTTP, DB, etc.)
│   ├── mappers/            # Mappers entre capas
│   └── repositories/       # Implementaciones concretas
├── presentation/            # Capa de Presentación (UI)
│   ├── blocs/              # Estados y eventos (BLoC)
│   ├── pages/              # Páginas/Pantallas
│   └── widgets/            # Widgets reutilizables
└── shared/                  # Compartido entre capas
    ├── constants/          # Constantes de la aplicación
    ├── extensions/         # Extensions de Dart
    └── widgets/            # Widgets compartidos
```

## 🎯 Principios Arquitectónicos

### Clean Architecture
- **Independencia de frameworks**: La lógica de negocio no depende de Flutter
- **Testabilidad**: Cada capa es testeable independientemente
- **Independencia de UI**: La UI puede cambiar sin afectar la lógica de negocio
- **Independencia de base de datos**: Los datos pueden cambiar de origen sin afectar las reglas de negocio

### Domain-Driven Design (DDD)
- **Entidades**: Objetos con identidad única
- **Value Objects**: Objetos inmutables definidos por sus valores
- **Agregados**: Grupos de entidades relacionadas
- **Repositorios**: Abstracciones para acceso a datos
- **Casos de Uso**: Orquestación de la lógica de negocio

### SOLID Principles
- **S**: Responsabilidad única por clase/módulo
- **O**: Abierto para extensión, cerrado para modificación
- **L**: Principio de sustitución de Liskov
- **I**: Segregación de interfaces
- **D**: Inversión de dependencias

## 🛠️ Stack Tecnológico

### Core
- **Flutter**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación

### State Management
- **flutter_bloc**: Gestión de estado reactiva
- **bloc_concurrency**: Control de concurrencia en BLoCs

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Generación automática de DI

### Networking
- **dio**: Cliente HTTP avanzado
- **connectivity_plus**: Detección de conectividad

### Data & Serialization
- **json_annotation**: Anotaciones para JSON
- **freezed**: Generación de modelos inmutables
- **dartz**: Programación funcional (Either, Option)

### Local Storage
- **shared_preferences**: Preferencias simples
- **hive**: Base de datos NoSQL local

### UI & UX
- **flutter_screenutil**: Adaptación responsiva
- **go_router**: Navegación declarativa

### Development Tools
- **very_good_analysis**: Reglas de análisis estrictas
- **build_runner**: Generación de código
- **logger**: Sistema de logging

### Testing
- **bloc_test**: Testing de BLoCs
- **mocktail**: Mocking para tests

## 🚀 Primeros Pasos

### Prerrequisitos

- Flutter SDK >= 3.13.0
- Dart SDK >= 3.1.0
- Android Studio / VS Code
- Git

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd serenithy_app
   ```

2. **Configurar el proyecto**
   ```bash
   make setup
   ```

3. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

4. **Ejecutar la aplicación**
   ```bash
   make run
   ```

## 📝 Comandos Disponibles

### Desarrollo
```bash
make run                    # Ejecutar la aplicación
make run-release           # Ejecutar en modo release
make devices               # Listar dispositivos
make logs                  # Ver logs de la aplicación
```

### Gestión de Dependencias
```bash
make deps                  # Instalar dependencias
make deps-upgrade          # Actualizar dependencias
make deps-outdated         # Ver dependencias desactualizadas
```

### Calidad de Código
```bash
make analyze               # Analizar código
make format                # Formatear código
make format-fix            # Formatear y arreglar
make lint                  # Análisis + formateo
```

### Testing
```bash
make test                  # Ejecutar todos los tests
make test-coverage         # Tests con cobertura
make test-unit             # Solo tests unitarios
make test-widget           # Solo tests de widgets
make test-integration      # Tests de integración
```

### Generación de Código
```bash
make generate              # Generar código (Freezed, Injectable)
make generate-watch        # Generar en modo watch
```

### Build
```bash
make build-debug           # Build debug
make build-release         # Build release
make build-ios             # Build iOS
make build-web             # Build web
```

### Utilidades
```bash
make clean                 # Limpiar proyecto
make clean-generated       # Limpiar archivos generados
make doctor                # Flutter doctor
make info                  # Información del proyecto
make help                  # Ver todos los comandos
```

## 🧪 Testing

### Estructura de Testing
```
test/
├── unit/                  # Tests unitarios
│   ├── domain/           # Tests del dominio
│   ├── application/      # Tests de casos de uso
│   └── infrastructure/   # Tests de infraestructura
├── widget/               # Tests de widgets
└── integration/          # Tests de integración
```

### Ejecutar Tests
```bash
# Todos los tests
make test

# Con cobertura
make test-coverage

# Por tipo
make test-unit
make test-widget
make test-integration
```

## 🔧 Configuración

### Variables de Entorno
```bash
# .env
ENVIRONMENT=development
API_BASE_URL=http://localhost:3000
API_VERSION=v1
APP_NAME=Serenithy
JWT_SECRET=your-secret-key
ENABLE_LOGGING=true
```

### Inyección de Dependencias
El proyecto usa `get_it` + `injectable` para DI:

```dart
// Registro automático
@injectable
class UserRepository implements IUserRepository {
  // implementation
}

// Uso
final userRepo = getIt<IUserRepository>();
```

## 📱 Patrones Implementados

### Repository Pattern
```dart
abstract class BaseRepository<T, ID> {
  Future<Either<DomainException, T>> findById(ID id);
  Future<Either<DomainException, List<T>>> findAll();
  Future<Either<DomainException, T>> create(T entity);
  // ...
}
```

### Use Case Pattern
```dart
abstract class BaseUseCase<Input, Output> {
  Future<Either<DomainException, Output>> execute(Input input);
}
```

### BLoC Pattern
```dart
class ExampleBloc extends BaseBloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(const InitialState());
  
  @override
  Stream<ExampleState> mapEventToState(ExampleEvent event) async* {
    // Handle events
  }
}
```

## 🔄 Flujo de Datos

1. **UI** dispara un evento al **BLoC**
2. **BLoC** ejecuta un **Use Case**
3. **Use Case** usa **Repositories** (interfaces)
4. **Repository Implementation** hace llamadas a **APIs/DB**
5. Los datos fluyen de vuelta transformándose en cada capa
6. **UI** recibe el nuevo estado y se actualiza

## 🎨 Convenciones de Código

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private**: `_leadingUnderscore`

### Structure Conventions
- Un archivo por clase principal
- Agrupar archivos relacionados en carpetas
- Usar barrel exports (`index.dart`)
- Imports relativos dentro del proyecto

### Documentation
- Documentar APIs públicas
- Usar `/// ` para documentación de Dart
- Incluir ejemplos de uso cuando sea apropiado

## 🚦 Estado del Proyecto

### ✅ Implementado
- [x] Estructura de arquitectura hexagonal
- [x] Configuración de dependencias
- [x] Sistema de configuración type-safe
- [x] Inyección de dependencias
- [x] Clases base para todas las capas
- [x] Manejo de errores funcional
- [x] Sistema de logging
- [x] Configuración de análisis de código

### 🔄 En Progreso
- [ ] Implementación de entidades específicas del dominio
- [ ] Casos de uso de autenticación
- [ ] Repositorios concretos
- [ ] Páginas de UI principales
- [ ] Tests unitarios e integración

### 📋 Por Hacer
- [ ] Internacionalización (i18n)
- [ ] Temas oscuro/claro
- [ ] Animaciones y transiciones
- [ ] Optimización de rendimiento
- [ ] Documentación técnica detallada

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abrir un Pull Request

### Reglas de Contribución
- Seguir las convenciones de código
- Incluir tests para nuevo código
- Mantener la cobertura de tests > 80%
- Documentar cambios significativos
- Usar mensajes de commit descriptivos

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Tu Nombre** - *Desarrollador Principal* - [@tu-usuario](https://github.com/tu-usuario)

## 🙏 Agradecimientos

- Clean Architecture por Robert C. Martin
- Domain-Driven Design por Eric Evans
- Flutter Team por el framework
- Comunidad de desarrolladores Flutter

---

**Nota**: Este proyecto sigue las mismas prácticas arquitectónicas que el backend de Serenithy en NestJS, asegurando consistencia en todo el stack tecnológico.

Para más información técnica, consulta la [documentación del backend](../serenithy-api/README.md).
