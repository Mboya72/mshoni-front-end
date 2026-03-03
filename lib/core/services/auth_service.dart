import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<void> saveSessionManually(Map<String, dynamic> data) async {
    await _saveSession(data);
  }

  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// --- FETCH SAVED DATA ---
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  /// --- DIRECT DJANGO SIGN UP ---
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': fullName.replaceAll(' ', '_').toLowerCase(),
          'full_name': fullName,
          'role': role.toUpperCase(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Save the session data (Token and User Info)
        await _saveSession(data);

        print("Success: Registered and Session Saved");
        return true;
      } else {
        print("Django Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Network Error: $e");
      return false;
    }
  }

  /// --- INTERNAL SESSION HELPER ---
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if Django sent back access/refresh tokens (SimpleJWT)
    if (data.containsKey('access')) {
      await prefs.setString(_tokenKey, data['access']);
    } else if (data.containsKey('token')) {
      await prefs.setString(_tokenKey, data['token']);
    }

    // Save the user details (the user object returned by Django)
    if (data.containsKey('user')) {
      await prefs.setString(_userKey, jsonEncode(data['user']));
    } else {
      // If user info is at top level of response
      await prefs.setString(_userKey, jsonEncode(data));
    }
  }

  /// --- HANDLE LOGIN RESPONSE ---
  Future<void> handleLoginResponse(String responseBody) async {
    final Map<String, dynamic> data = jsonDecode(responseBody);
    final prefs = await SharedPreferences.getInstance();

    // Store JWT Token (SimpleJWT uses 'access')
    if (data.containsKey('access')) {
      await prefs.setString('auth_token', data['access']);
    }

    // Store User Profile
    if (data.containsKey('user')) {
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    print("User logged out locally.");
  }
}