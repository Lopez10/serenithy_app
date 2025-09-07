import 'package:dartz/dartz.dart';
import '../exceptions/domain_exceptions.dart';

/// Interfaz base para repositorios siguiendo el patrón Repository
/// Utiliza Either para manejo funcional de errores
abstract class BaseRepository<T, ID> {
  /// Buscar una entidad por ID
  Future<Either<DomainException, T>> findById(ID id);

  /// Buscar todas las entidades con paginación opcional
  Future<Either<DomainException, List<T>>> findAll({
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  });

  /// Crear una nueva entidad
  Future<Either<DomainException, T>> create(T entity);

  /// Actualizar una entidad existente
  Future<Either<DomainException, T>> update(ID id, T entity);

  /// Eliminar una entidad por ID
  Future<Either<DomainException, void>> delete(ID id);

  /// Verificar si existe una entidad con el ID dado
  Future<Either<DomainException, bool>> exists(ID id);
}

/// Resultado paginado para consultas
class PaginatedResult<T> {
  const PaginatedResult({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<T> data;
  final int total;
  final int page;
  final int limit;

  int get totalPages => (total / limit).ceil();
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}
