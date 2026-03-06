import 'dart:convert';
import 'package:flutter/foundation.dart'; // <--- ADD THIS LINE
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/api_config.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Google Sign In Instance (v7+ singleton style)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const String _tokenKey = 'access_token';
  static const String _refreshKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // --- 1. USER PROFILE ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    try {
      return jsonDecode(userStr) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // --- 2. ACCESS TOKEN (FIXED: Moved inside the class) ---
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null) {
      debugPrint("🔑 Token retrieved successfully");
    } else {
      debugPrint("⚠️ No token found in storage");
    }
    return token;
  }

  // --- 3. GOOGLE SIGN IN ---
  Future<bool> signInWithGoogle(String role) async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return false;

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/users/google/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': idToken,
          'role': role.toLowerCase(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Google Auth Error: $e");
      return false;
    }
  }

  // --- 4. SIGN UP ---
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
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
          'username': email.split('@')[0],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("SignUp Error: $e");
      return false;
    }
  }

  // --- 5. LOGIN ---
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
      debugPrint("Login Error: $e");
      return false;
    }
  }

  // --- SESSION MANAGEMENT ---
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey('access')) await prefs.setString(_tokenKey, data['access']);
    if (data.containsKey('refresh')) await prefs.setString(_refreshKey, data['refresh']);
    await prefs.setString(_userKey, jsonEncode(data));
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await prefs.clear();
  }
} // <--- END OF CLASS