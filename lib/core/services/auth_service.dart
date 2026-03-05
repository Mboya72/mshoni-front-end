import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _tokenKey = 'access_token';
  static const String _refreshKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // --- GETTERS ---
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    return userStr != null ? jsonDecode(userStr) : null;
  }

  // --- SIGN UP ---
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role, // 'tailor', 'customer', etc.
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'role': role.toLowerCase(),
          // Django still needs a unique username; email prefix is a safe bet
          'username': email.split('@')[0],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      return false;
    } catch (e) {
      print("SignUp Error: $e");
      return false;
    }
  }

  // --- LOGIN ---
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // --- TOKEN REFRESH ---
  // Call this if a 401 Unauthorized occurs
  Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString(_refreshKey);
    if (refresh == null) return null;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.tokenRefresh),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString(_tokenKey, data['access']);
        return data['access'];
      }
    } catch (e) {
      print("Refresh Error: $e");
    }
    return null;
  }

  // --- SESSION SAVER ---
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Save JWT Tokens
    if (data.containsKey('access')) await prefs.setString(_tokenKey, data['access']);
    if (data.containsKey('refresh')) await prefs.setString(_refreshKey, data['refresh']);

    // Save User Profile (We added user_id and role to the login response earlier)
    await prefs.setString(_userKey, jsonEncode(data));
    print("✅ Mshoni session active: ${data['role']}");
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}