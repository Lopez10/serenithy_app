import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../application/dto/user_dto.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/exceptions/domain_exceptions.dart';
import '../../shared/constants/app_constants.dart';
import '../adapters/http_client.dart';
import '../mappers/user_mapper.dart';

/// Implementación concreta del repositorio de usuarios
@Injectable(as: IUserRepository)
class UserRepositoryImpl implements IUserRepository {
  const UserRepositoryImpl(
    this._httpClient,
    this._userMapper,
  );

  final HttpClient _httpClient;
  final UserMapper _userMapper;

  @override
  Future<Either<DomainException, User>> findById(String id) async {
    return await _httpClient.get(
      '${ApiConstants.usersEndpoint}/$id',
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, List<User>>> findAll({
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (filters != null) queryParams.addAll(filters);

    return await _httpClient.get(
      ApiConstants.usersEndpoint,
      queryParameters: queryParams,
      fromJson: (json) {
        final List<dynamic> dataList = json['data'];
        return dataList
            .map((item) => _userMapper.toDomain(
                  UserResponseDto.fromJson(item),
                ))
            .toList();
      },
    );
  }

  @override
  Future<Either<DomainException, User>> create(User entity) async {
    final dto = _userMapper.toDto(entity);
    
    return await _httpClient.post(
      ApiConstants.usersEndpoint,
      data: dto.toJson(),
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, User>> update(String id, User entity) async {
    final dto = _userMapper.toDto(entity);
    
    return await _httpClient.put(
      '${ApiConstants.usersEndpoint}/$id',
      data: dto.toJson(),
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, void>> delete(String id) async {
    return await _httpClient.delete('${ApiConstants.usersEndpoint}/$id');
  }

  @override
  Future<Either<DomainException, bool>> exists(String id) async {
    final result = await findById(id);
    return result.fold(
      (error) => const Right(false),
      (user) => const Right(true),
    );
  }

  @override
  Future<Either<DomainException, User?>> findByEmail(Email email) async {
    return await _httpClient.get(
      '${ApiConstants.usersEndpoint}/by-email',
      queryParameters: {'email': email.value},
      fromJson: (json) {
        if (json['data'] == null) return null;
        return _userMapper.toDomain(
          UserResponseDto.fromJson(json['data']),
        );
      },
    );
  }

  @override
  Future<Either<DomainException, User>> register(User user) async {
    final registerDto = RegisterUserDto(
      name: user.name.value,
      email: user.email.value,
      password: user.password.value,
      confirmPassword: user.password.value,
    );

    return await _httpClient.post(
      '${ApiConstants.authEndpoint}/register',
      data: registerDto.toJson(),
      fromJson: (json) => _userMapper.authResponseToDomain(
        AuthResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, User>> login(
    Email email,
    String password,
  ) async {
    final loginDto = LoginUserDto(
      email: email.value,
      password: password,
    );

    return await _httpClient.post(
      '${ApiConstants.authEndpoint}/login',
      data: loginDto.toJson(),
      fromJson: (json) => _userMapper.authResponseToDomain(
        AuthResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, User>> verifyEmail(
    String userId,
    String verificationCode,
  ) async {
    final verifyDto = VerifyEmailDto(verificationCode: verificationCode);

    return await _httpClient.post(
      '${ApiConstants.authEndpoint}/verify-email',
      data: verifyDto.toJson(),
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, User>> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    final changePasswordDto = ChangePasswordDto(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: newPassword,
    );

    return await _httpClient.put(
      '${ApiConstants.usersEndpoint}/$userId/change-password',
      data: changePasswordDto.toJson(),
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, bool>> existsByEmail(Email email) async {
    final result = await findByEmail(email);
    return result.fold(
      (error) => const Right(false),
      (user) => Right(user != null),
    );
  }

  @override
  Future<Either<DomainException, User>> updateProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    return await _httpClient.put(
      '${ApiConstants.usersEndpoint}/$userId/profile',
      data: updates,
      fromJson: (json) => _userMapper.toDomain(
        UserResponseDto.fromJson(json['data']),
      ),
    );
  }

  @override
  Future<Either<DomainException, void>> softDelete(String userId) async {
    return await _httpClient.delete('${ApiConstants.usersEndpoint}/$userId');
  }

  @override
  Future<Either<DomainException, Map<String, dynamic>>> getUserStats(
    String userId,
  ) async {
    return await _httpClient.get(
      '${ApiConstants.usersEndpoint}/$userId/stats',
      fromJson: (json) => json['data'] as Map<String, dynamic>,
    );
  }
}
