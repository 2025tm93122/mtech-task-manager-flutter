import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  const AuthService();

  Future<ParseUser?> currentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user;
  }

  Future<ParseUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = ParseUser(normalizedEmail, password, normalizedEmail)
      ..set<String>('displayName', displayName.trim());

    final response = await user.signUp();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Registration failed.');
    }
    return response.result as ParseUser;
  }

  Future<ParseUser> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = ParseUser(normalizedEmail, password, null);
    final response = await user.login();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Login failed.');
    }
    return response.result as ParseUser;
  }

  Future<void> logout() async {
    final user = await currentUser();
    if (user == null) return;
    final response = await user.logout();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Logout failed.');
    }
  }
}
