import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/api_config.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  // Use the singleton instance and manage initialization for version 7.x
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  late final Future<void> _initialization;

  AuthService._internal() {
    _initialization = _googleSignIn.initialize(
      serverClientId: '711009292399-snhm4jdupd893e7vtgb67u5grg0459fh.apps.googleusercontent.com',
    );
  }

  static const String _tokenKey = 'access_token';
  static const String _refreshKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // --- TOKEN RETRIEVAL ---

  // Satisfies Customer/Tailor Home Screens
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Satisfies SignIn Screen
  Future<String?> getToken() async => await getAccessToken();

  // --- USER PROFILE ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    try {
      final Map<String, dynamic> data = jsonDecode(userStr);
      return data['user'] ?? data;
    } catch (e) {
      return null;
    }
  }

  // --- GOOGLE SIGN IN ---
  Future<bool> signInWithGoogle(String role) async {
    try {
      await _initialization;
      
      // Use authenticate() instead of signIn() for version 7.x
      // Scopes are passed via scopeHint if needed during authentication
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: <String>['email', 'profile'],
      );

      // authentication is now a synchronous getter
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return false;

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/users/google/"),
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
      debugPrint("❌ Google Auth Error: $e");
      return false;
    }
  }

  // --- MANUAL LOGIN ---
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
      return false;
    }
  }

  // --- SIGN UP ---
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
          'username': email,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // --- SESSION MANAGEMENT ---
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = data['access'] ?? data['access_token'];
    final refresh = data['refresh'] ?? data['refresh_token'];

    if (token != null) await prefs.setString(_tokenKey, token);
    if (refresh != null) await prefs.setString(_refreshKey, refresh);

    await prefs.setString(_userKey, jsonEncode(data));
  }

  // --- LOGOUT ---
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await _initialization;
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect(); 
    } catch (_) {}
    await prefs.clear();
  }
}
