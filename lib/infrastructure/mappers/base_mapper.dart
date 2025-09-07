/// Mapper base para convertir entre entidades de dominio y DTOs
abstract class BaseMapper<Domain, Dto> {
  /// Convierte de DTO a entidad de dominio
  Domain toDomain(Dto dto);

  /// Convierte de entidad de dominio a DTO
  Dto toDto(Domain domain);

  /// Convierte una lista de DTOs a entidades de dominio
  List<Domain> toDomainList(List<Dto> dtos) {
    return dtos.map(toDomain).toList();
  }

  /// Convierte una lista de entidades de dominio a DTOs
  List<Dto> toDtoList(List<Domain> domains) {
    return domains.map(toDto).toList();
  }
}

/// Mapper bidireccional con conversión parcial
abstract class PartialMapper<Domain, CreateDto, UpdateDto, ResponseDto> {
  /// Convierte DTO de respuesta a entidad de dominio
  Domain toDomain(ResponseDto dto);

  /// Convierte entidad de dominio a DTO de creación
  CreateDto toCreateDto(Domain domain);

  /// Convierte entidad de dominio a DTO de actualización
  UpdateDto toUpdateDto(Domain domain);

  /// Convierte entidad de dominio a DTO de respuesta
  ResponseDto toResponseDto(Domain domain);
}
