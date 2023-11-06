// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  const User({
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.id,
  });
  const User.empty()
      : this(avatar: 'avatar', name: 'name', createdAt: 'createdAt', id: '1');

  final String? createdAt;
  final String? name;
  final String? avatar;
  final String? id;

  @override
  List<Object?> get props => [id];
}
