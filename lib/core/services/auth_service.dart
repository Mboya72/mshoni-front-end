import 'package:supabase_flutter/supabase_flutter.dart';
import '../network/api_config.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user session
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  /// --- EMAIL & PASSWORD SIGN UP ---
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': role.toLowerCase(), // Sent to your Django Signal/Adapter
      },
    );
  }

  /// --- EMAIL & PASSWORD SIGN IN ---
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// --- OAUTH (GOOGLE / FACEBOOK) ---
  Future<void> signInWithSocial(OAuthProvider provider, String role) async {
    await _supabase.auth.signInWithOAuth(
      provider,
      redirectTo: ApiConfig.redirectUrl,
      queryParams: {
        'role': role.toLowerCase(), // Pass role to Django SocialAdapter
      },
    );
  }

  /// --- SIGN OUT ---
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}