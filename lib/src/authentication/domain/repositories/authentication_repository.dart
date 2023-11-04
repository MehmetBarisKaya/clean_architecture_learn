import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  ResultFuture<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });
  ResultFuture<List<User>> getUsers();
}
