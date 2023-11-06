import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/create_user.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/get_users.dart';
import 'package:clean_architecture/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthenticationCubitMock extends Mock implements AuthenticationCubit {}

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late AuthenticationCubit authenticationCubit;
  late CreateUser createUser;
  late GetUsers getUsers;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: 'message', statusCode: 505);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    authenticationCubit =
        AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });
  tearDown(() => authenticationCubit.close());
  test('initial state should be [AuthenticationInitial]', () async {
    expect(authenticationCubit.state, AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emits [CreatingUser, UserCreated] when successful.',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authenticationCubit;
      },
      act: (bloc) => bloc.createUser(
        createdAt: tCreateUserParams.createdAt,
        avatar: tCreateUserParams.avatar,
        name: tCreateUserParams.name,
      ),
      expect: () => [CreatingUsers(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emits [CreatingUser, AuthenticationError] when unsuccessful.',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async {
            return const Left(tApiFailure);
          },
        );
        return authenticationCubit;
      },
      act: (bloc) => bloc.createUser(
        createdAt: tCreateUserParams.createdAt,
        avatar: tCreateUserParams.avatar,
        name: tCreateUserParams.name,
      ),
      expect: () =>
          [CreatingUsers(), AuthenticationError(tApiFailure.errorMessage)],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emits [GettingUser, UserLoaded] when successful.',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return authenticationCubit;
      },
      act: (bloc) => bloc.getUsers(),
      expect: () => [GettingUsers(), const UserLoaded([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emits [GettingUser, AuthenticationError] when unsuccessful.',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async {
            return const Left(tApiFailure);
          },
        );
        return authenticationCubit;
      },
      act: (bloc) => bloc.getUsers(),
      expect: () =>
          [GettingUsers(), AuthenticationError(tApiFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
