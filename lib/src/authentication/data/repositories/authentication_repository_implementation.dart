import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImplementation extends AuthenticationRepository {
  AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    ///Test Driven
    ///call the remote data source
    ///check if the method is returns the proper data
    ///check if when the remoteDataSource  throws an exception , return a
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(
        ApiFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final response = await _remoteDataSource.getUsers();
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
