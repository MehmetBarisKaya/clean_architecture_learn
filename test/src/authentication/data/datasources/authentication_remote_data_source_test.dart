import 'dart:convert';

import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/utils/constants.dart';
import 'package:clean_architecture/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_architecture/src/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRepoDataSrcImpl(client);
    registerFallbackValue(Uri());
  });
  group('createUser', () {
    test('should complete successfully  when the status code 200 or 201',
        () async {
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      final result = remoteDataSource.createUser(
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      );

      expect(
        result,
        completes,
      );
      verify(
        () => client.post(
          Uri.parse('$kBaseUrl/users'),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'avatar': 'avatar',
            'name': 'name',
          }),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
    test(
      'should return [ApiException] when status code is not 200 or 201',
      () {
        when(
          () => client.post(any(), body: any(named: 'body')),
        ).thenAnswer(
          (_) async => http.Response('User not created', 400),
        );
        final result = remoteDataSource.createUser;
        expect(
          () => result(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          throwsA(
            const ApiException(message: 'User not created', statusCode: 400),
          ),
        );
        verify(
          () => client.post(
            Uri.parse('$kBaseUrl/users'),
            body: jsonEncode({
              'createdAt': 'createdAt',
              'avatar': 'avatar',
              'name': 'name',
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
  group('getUsers', () {
    final tUsers = [
      UserModel(
        avatar: 'avatar',
        name: 'name',
        createdAt: 'createdAt',
        id: '1',
      ),
    ];
    test('should complete successfully  when the status code 200 or 201',
        () async {
      when(
        () => client.get(
          any(),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );

      final result = await remoteDataSource.getUsers();

      expect(
        result,
        equals(tUsers),
      );
      verify(
        () => client.get(
          Uri.https(
            kBaseUrl,
            '/api/users',
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
    test(
      'should return [ApiException] when status code is not 200 or 201',
      () {
        when(
          () => client.post(any(), body: any(named: 'body')),
        ).thenAnswer(
          (_) async => http.Response('User not created', 400),
        );
        final result = remoteDataSource.createUser;
        expect(
          () => result(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          throwsA(
            const ApiException(message: 'User not created', statusCode: 400),
          ),
        );
        verify(
          () => client.post(
            Uri.parse('$kBaseUrl/users'),
            body: jsonEncode({
              'createdAt': 'createdAt',
              'avatar': 'avatar',
              'name': 'name',
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
}
