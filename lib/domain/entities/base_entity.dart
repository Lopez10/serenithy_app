import 'package:equatable/equatable.dart';

/// Entidad base abstracta que define propiedades comunes
/// Equivalente a la entidad base en NestJS
abstract class BaseEntity extends Equatable {
  const BaseEntity({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  @override
  List<Object?> get props => [id, createdAt, updatedAt, deletedAt];
}
