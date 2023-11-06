import 'package:clean_architecture/core/use_case/use_case.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UseCaseWithOutParams<List<User>> {
  GetUsers(this._repository);

  final AuthenticationRepository _repository;
  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
