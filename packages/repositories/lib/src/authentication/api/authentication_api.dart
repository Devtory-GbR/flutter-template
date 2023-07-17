import 'dart:convert';

import 'package:repositories/repositories.dart';

class AuthenticationApiProvider {
  final MyAppHttpClient client;

  final String _urlRefreshToken = '/auth/refreshToken';
  final String _urlLogin = '/auth/login';
  final String _urlLogout = '/auth/logout';

  AuthenticationApiProvider({required this.client});

  Future<String> refreshToken(String token) async {
    final response = await client.post(
      client.buildUri('/posts'),
      body: {'token': token},
    );

    return jsonDecode(response.body)['token'];
  }

  Future<String> login(String username, String password) async {
    final response = await client.post(
      client.buildUri('/posts'),
      body: {'user': username, 'password': password},
    );

    // to do check here just the response if the request was succesfull
    // for now we just to is here quite simple
    if (username.toLowerCase() != 'max') {
      throw UserPasswordIncorrectException();
    }

    //return jsonDecode(response.body)['token'];
    return jsonDecode(response.body)['id'].toString();
  }

  Future<void> logout() async {
    await client.post(client.buildUri(_urlLogout));
  }
}
