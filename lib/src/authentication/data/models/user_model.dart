import 'dart:convert';

import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.createdAt,
    required super.name,
    required super.avatar,
    required super.id,
  });

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          avatar: map['avatar'] as String?,
          name: map['name'] as String?,
          createdAt: map['createdAt'] as String?,
          id: map['id'] as String?,
        );

  User copyWith({
    String? createdAt,
    String? name,
    String? avatar,
    String? id,
  }) {
    return User(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
    );
  }

  DataMap toMap() {
    return {
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
      'id': id,
    };
  }

  String toJson() => jsonEncode(toMap());
}
