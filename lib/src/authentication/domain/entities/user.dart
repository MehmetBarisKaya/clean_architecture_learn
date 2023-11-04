import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  const User({
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.id,
  });
  const User.empty()
      : this(avatar: 'avatar', name: 'name', createdAt: 'createdAt', id: 1);

  final String? createdAt;
  final String? name;
  final String? avatar;
  final int? id;

  @override
  List<Object?> get props => [id];
}
