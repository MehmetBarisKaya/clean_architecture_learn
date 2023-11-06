// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture/core/services/injection_containers.dart';
import 'package:clean_architecture/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:clean_architecture/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is UserCreated) {
            getUsers();
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return const AddUserDialog();
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            body: state is GettingUsers
                ? const LoadingColumn(message: 'Fetching Users')
                : state is CreatingUsers
                    ? const LoadingColumn(message: 'Creating User')
                    : state is UserLoaded
                        ? ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (BuildContext context, int index) {
                              ListTile(
                                leading: Image.network(
                                  state.users[index].avatar ?? '',
                                ),
                                title: Text(state.users[index].name ?? ''),
                                subtitle:
                                    Text(state.users[index].createdAt ?? ''),
                              );

                              return null;
                            },
                          )
                        : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class LoadingColumn extends StatelessWidget {
  const LoadingColumn({
    required this.message,
    super.key,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        Text('Loading...'),
      ],
    );
  }
}
