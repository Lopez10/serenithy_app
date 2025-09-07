# ================================
# Serenithy Flutter App - Makefile
# ================================

# Variables
FLUTTER_VERSION := 3.13.0
DART_VERSION := 3.1.0

.PHONY: help
help: ## Muestra esta ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ================================
# Setup y Configuración
# ================================

.PHONY: setup
setup: ## Configura el proyecto inicial
	@echo "🚀 Configurando el proyecto Serenithy Flutter..."
	flutter --version
	flutter doctor
	flutter pub get
	make generate
	@echo "✅ Proyecto configurado correctamente"

.PHONY: clean-setup
clean-setup: clean setup ## Limpieza completa y reconfiguración

# ================================
# Gestión de Dependencias
# ================================

.PHONY: deps
deps: ## Instala las dependencias
	@echo "📦 Instalando dependencias..."
	flutter pub get

.PHONY: deps-upgrade
deps-upgrade: ## Actualiza las dependencias
	@echo "⬆️  Actualizando dependencias..."
	flutter pub upgrade

.PHONY: deps-outdated
deps-outdated: ## Muestra dependencias desactualizadas
	flutter pub outdated

# ================================
# Generación de Código
# ================================

.PHONY: generate
generate: ## Genera código automático (Freezed, Injectable, etc.)
	@echo "🔧 Generando código automático..."
	flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: generate-watch
generate-watch: ## Genera código automático en modo watch
	@echo "👀 Generando código automático en modo watch..."
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# ================================
# Calidad de Código
# ================================

.PHONY: analyze
analyze: ## Analiza el código
	@echo "🔍 Analizando código..."
	flutter analyze

.PHONY: format
format: ## Formatea el código
	@echo "✨ Formateando código..."
	dart format lib/ test/ --set-exit-if-changed

.PHONY: format-fix
format-fix: ## Formatea y arregla el código
	@echo "🔧 Formateando y arreglando código..."
	dart format lib/ test/

.PHONY: lint
lint: analyze format ## Ejecuta análisis y formateo

# ================================
# Testing
# ================================

.PHONY: test
test: ## Ejecuta todos los tests
	@echo "🧪 Ejecutando tests..."
	flutter test

.PHONY: test-coverage
test-coverage: ## Ejecuta tests con cobertura
	@echo "📊 Ejecutando tests con cobertura..."
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

.PHONY: test-unit
test-unit: ## Ejecuta solo tests unitarios
	flutter test test/unit/

.PHONY: test-widget
test-widget: ## Ejecuta solo tests de widgets
	flutter test test/widget/

.PHONY: test-integration
test-integration: ## Ejecuta tests de integración
	flutter test integration_test/

# ================================
# Build y Deploy
# ================================

.PHONY: build-debug
build-debug: ## Build en modo debug
	@echo "🔨 Construyendo en modo debug..."
	flutter build apk --debug

.PHONY: build-release
build-release: ## Build en modo release
	@echo "🚀 Construyendo en modo release..."
	flutter build apk --release

.PHONY: build-ios
build-ios: ## Build para iOS
	@echo "🍎 Construyendo para iOS..."
	flutter build ios --release

.PHONY: build-web
build-web: ## Build para web
	@echo "🌐 Construyendo para web..."
	flutter build web

# ================================
# Desarrollo
# ================================

.PHONY: run
run: ## Ejecuta la aplicación en modo debug
	@echo "🏃 Ejecutando aplicación..."
	flutter run

.PHONY: run-release
run-release: ## Ejecuta la aplicación en modo release
	flutter run --release

.PHONY: devices
devices: ## Lista dispositivos disponibles
	flutter devices

.PHONY: emulators
emulators: ## Lista emuladores disponibles
	flutter emulators

# ================================
# Limpieza
# ================================

.PHONY: clean
clean: ## Limpia archivos generados
	@echo "🧹 Limpiando archivos generados..."
	flutter clean
	flutter pub get

.PHONY: clean-generated
clean-generated: ## Limpia solo archivos generados automáticamente
	@echo "🗑️  Eliminando archivos generados..."
	find lib -name "*.g.dart" -delete
	find lib -name "*.freezed.dart" -delete
	find lib -name "*.config.dart" -delete

# ================================
# Utilidades
# ================================

.PHONY: doctor
doctor: ## Ejecuta flutter doctor
	flutter doctor

.PHONY: info
info: ## Muestra información del proyecto
	@echo "📋 Información del proyecto:"
	@echo "Flutter version: $(FLUTTER_VERSION)"
	@echo "Dart version: $(DART_VERSION)"
	@echo "Project: Serenithy Flutter App"
	@echo "Architecture: Hexagonal (Clean Architecture)"

.PHONY: logs
logs: ## Muestra logs de la aplicación
	flutter logs

.PHONY: create-launcher-icons
create-launcher-icons: ## Genera iconos del launcher
	flutter pub run flutter_launcher_icons:main

.PHONY: create-splash
create-splash: ## Genera splash screen
	flutter pub run flutter_native_splash:create

# ================================
# Git Hooks
# ================================

.PHONY: install-hooks
install-hooks: ## Instala git hooks
	@echo "🪝 Instalando git hooks..."
	cp scripts/pre-commit .git/hooks/
	chmod +x .git/hooks/pre-commit

# ================================
# Scripts de CI/CD
# ================================

.PHONY: ci
ci: deps generate lint test ## Ejecuta pipeline completo de CI

.PHONY: pre-commit
pre-commit: format-fix analyze test ## Ejecuta checks antes de commit

# ================================
# Comandos por defecto
# ================================

.DEFAULT_GOAL := help
