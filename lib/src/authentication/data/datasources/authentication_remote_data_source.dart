// ignore_for_file: only_throw_errors

import 'dart:convert';

import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/core/utils/constants.dart';
import 'package:clean_architecture/core/utils/typedef.dart';
import 'package:clean_architecture/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

class AuthRepoDataSrcImpl extends AuthenticationRemoteDataSource {
  AuthRepoDataSrcImpl(this._client);

  final http.Client _client;
  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$kBaseUrl/users'),
        body: jsonEncode({
          'createdAt': 'createdAt',
          'avatar': 'avatar',
          'name': 'name',
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.https(kBaseUrl, '/api/users'));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map(UserModel.fromMap)
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
