part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class CreatingUsers extends AuthenticationState {}

final class GettingUsers extends AuthenticationState {}

final class UserCreated extends AuthenticationState {}

final class UserLoaded extends AuthenticationState {
  const UserLoaded(this.users);

  final List<User> users;

  @override
  List<Object> get props => users.map((e) => e.id!).toList();
}

final class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);

  final String message;
  @override
  List<Object> get props => [message];
}
