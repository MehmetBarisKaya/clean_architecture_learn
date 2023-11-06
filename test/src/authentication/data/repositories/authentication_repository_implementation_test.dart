import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });
  const tException = ApiException(message: 'Unknown error', statusCode: 500);
  group('createUser', () {
    const createdAt = 'w.createdAt';
    const avatar = 'w.avatar';
    const name = 'w.name';
    test(
      'call [RemoteDataSource.createUser] and complete successfully           '
      'when the call to the remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
            name: any(named: 'name'),
          ),

          ///Future.value means void
        ).thenAnswer((_) => Future.value());

        ///act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        ///assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        );
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when the call to the remote data source   '
      'is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
            name: any(named: 'name'),
          ),

          ///Future.value means void
        ).thenThrow(
          tException,
        );

        ///act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        ///assert
        expect(
          result,
          equals(
            Left(
              ApiFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUser', () {
    test(
      'call [RemoteDataSource.getUsers] and return [List<User>]           '
      'when the call to the remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.getUsers(),

          ///Future.value means void
        ).thenAnswer((_) async => []);

        ///act
        final result = await repoImpl.getUsers();

        ///assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ApiFailure] when the call to the remote data source   '
      'is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.getUsers(),

          ///Future.value means void
        ).thenThrow(
          tException,
        );

        ///act
        final result = await repoImpl.getUsers();

        ///assert
        expect(
          result,
          equals(
            Left(
              ApiFailure.fromException(
                tException,
              ),
            ),
          ),
        );
        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
