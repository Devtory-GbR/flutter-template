import 'dart:async';

import 'package:http/http.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/authentication/api/authentication_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository {
  AuthenticationRepository();

  static const _kTokenPersistenceKey = '__token_persistence_key__';

  final _controller = StreamController<AuthenticationStatus>();
  String _token = '';

  String get token => _token;
  Stream<AuthenticationStatus> get status => _controller.stream;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kTokenPersistenceKey) ?? '';

    if (_token.isEmpty) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return;
    }

    // at thse point we want to check if the token is still valid
    await refreshToken(_token);
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final api = AuthenticationApiProvider(
      client: MyAppHttpClient(Client(), needsAuthorization: false),
    );

    try {
      final token = await api.login(username, password);
      await _setToken(token);
    } finally {
      api.client.close();
    }
  }

  void logOut() async {
    _removeToken();
    final api = AuthenticationApiProvider(client: MyAppHttpClient(Client()));

    try {
      await api.logout();
    } finally {
      api.client.close();
    }
  }

  Future<String> refreshToken(String token) async {
    final api = AuthenticationApiProvider(
      client: MyAppHttpClient(Client(), needsAuthorization: false),
    );

    try {
      final token = await api.refreshToken(_token);
      await _setToken(token);
      return token;
    } catch (_) {
      _removeToken();
      rethrow;
    } finally {
      api.client.close();
    }
  }

  void dispose() => _controller.close();

  Future<void> _setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenPersistenceKey, token);
    MyAppHttpClient.authToken = token;
    _token = token;

    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> _removeToken() async {
    _controller.add(AuthenticationStatus.unauthenticated);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenPersistenceKey);
    MyAppHttpClient.authToken = '';
    _token = '';
  }
}
