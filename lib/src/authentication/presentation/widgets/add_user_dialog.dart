import 'package:clean_architecture/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          child: Padding(
            padding: context.padding.medium,
            child: Column(
              children: [
                const TextField(),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationCubit>().createUser(
                          createdAt: 'createdAt',
                          name: 'name',
                          avatar: 'avatar',
                        );
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
