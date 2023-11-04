import 'package:clean_architecture/core/use_case/use_case.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class CreateUser extends UseCaseWithParams<void, CreateUserParams> {
  CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(CreateUserParams params) async =>
      _repository.createUser(
        avatar: params.avatar,
        name: params.name,
        createdAt: params.createdAt,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });
  const CreateUserParams.empty()
      : this(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        );

  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
