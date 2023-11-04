import 'package:clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers useCase;
  setUp(() {
    repository = MockAuthRepo();
    useCase = GetUsers(repository);
  });
  const testUserResponse = [User.empty()];
  test('call [AuthRepo.getUsers] and return List<User>', () async {
    //Arrange
    when(
      () => repository.getUsers(),
    ).thenAnswer((_) async => const Right(testUserResponse));

    //Act
    final response = await useCase();

    //Assert
    expect(
      response,
      equals(const Right<dynamic, List<User>>(testUserResponse)),
    );
    verify(
      () => repository.getUsers(),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
