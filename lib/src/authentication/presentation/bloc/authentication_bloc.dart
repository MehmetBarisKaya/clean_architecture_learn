import 'package:bloc/bloc.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/create_user.dart';
import 'package:clean_architecture/src/authentication/domain/use_cases/get_users.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUserHandler);
  }
  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(CreatingUsers());
    final result = await _createUser(
      CreateUserParams(
        createdAt: event.createdAt,
        name: event.name,
        avatar: event.avatar,
      ),
    );
    result.fold(
      (failure) => emit(
        AuthenticationError(
          failure.errorMessage,
        ),
      ),
      (_) => emit(UserCreated()),
    );
  }

  Future<void> _getUserHandler(
    GetUsersEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(GettingUsers());
    final result = await _getUsers();

    result.fold(
      (failure) => emit(
        AuthenticationError(
          failure.errorMessage,
        ),
      ),
      (users) => emit(UserLoaded(users)),
    );
  }
}
