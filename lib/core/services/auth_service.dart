import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Keys for SharedPreferences - Use these everywhere to avoid typos
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _refreshKey = 'refresh_token';

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
          // Generating a URL-safe username
          'username': fullName.replaceAll(' ', '_').toLowerCase(),
          'full_name': fullName,
          'role': role.toUpperCase(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Save session logic (Tokens + User Profile)
        await _saveSession(data);
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

  /// --- UNIVERSAL SESSION SAVER ---
  /// Works for both Login and SignUp responses
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Handle Tokens (SimpleJWT format: 'access' and 'refresh')
    if (data.containsKey('access')) {
      await prefs.setString(_tokenKey, data['access']);
    } else if (data.containsKey('token')) {
      await prefs.setString(_tokenKey, data['token']);
    }

    if (data.containsKey('refresh')) {
      await prefs.setString(_refreshKey, data['refresh']);
    }

    // 2. Handle User Data
    // If the backend wraps user info in a 'user' key, use that.
    // Otherwise, check if 'email' exists at top level (meaning the whole map is the user)
    if (data.containsKey('user')) {
      await prefs.setString(_userKey, jsonEncode(data['user']));
    } else if (data.containsKey('email') || data.containsKey('username')) {
      await prefs.setString(_userKey, jsonEncode(data));
    }

    print("✅ Session saved successfully.");
  }

  /// --- EXTERNAL LOGIN HANDLER ---
  /// Call this when you receive a response from your SignInScreen
  Future<void> handleLoginResponse(String responseBody) async {
    final Map<String, dynamic> data = jsonDecode(responseBody);
    await _saveSession(data);
  }

  /// --- LOGOUT ---
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_refreshKey);
    print("User logged out locally.");
  }
}