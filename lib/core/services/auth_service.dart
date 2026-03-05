import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Added this
import '../network/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Initialize Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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

  // --- GOOGLE SIGN IN ---
  Future<bool> signInWithGoogle(String role) async {
    try {
      // 1. Trigger the native Google overlay
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false; // User cancelled the selection

      // 2. Get the auth details (token)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return false;

      // 3. Exchange Google Token for Django JWT
      // Ensure ApiConfig.googleLogin points to something like /api/auth/google/
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/auth/google/"),
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
      print("Google Auth Error: $e");
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

    if (data.containsKey('access')) await prefs.setString(_tokenKey, data['access']);
    if (data.containsKey('refresh')) await prefs.setString(_refreshKey, data['refresh']);

    await prefs.setString(_userKey, jsonEncode(data));
    print("✅ Mshoni session active: ${data['role']}");
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await _googleSignIn.signOut(); // Ensure Google is also logged out
    await prefs.clear();
  }
}