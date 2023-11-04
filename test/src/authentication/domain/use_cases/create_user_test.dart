import 'package:clean_architecture/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/create_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late CreateUser useCase;
  setUp(() {
    repository = MockAuthRepo();
    useCase = CreateUser(repository);
  });
  const params = CreateUserParams.empty();
  test('call [AuthRepo.createUser]', () async {
    //Arrange
    when(
      () => repository.createUser(
        createdAt: any(named: 'createdAt'),
        avatar: any(named: 'avatar'),
        name: any(named: 'name'),
      ),
    ).thenAnswer((_) async => const Right(null));

    //Act
    final response = await useCase(params);

    //Assert
    expect(response, equals(const Right<dynamic, void>(null)));
    verify(
      () => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      ),
    ).called(1);
  });
}
