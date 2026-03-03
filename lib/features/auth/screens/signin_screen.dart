import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/social_auth_buttons.dart';
import './select_role_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Use your Django service

  bool _obscurePassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  /// --- DJANGO LOGIN LOGIC ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // 1. Save session using the helper in AuthService
        // This handles the 'access' token and the 'user' object
        await _authService.handleLoginResponse(response.body);

        final Map<String, dynamic> data = jsonDecode(response.body);

        // 2. Safely extract role
        // Nested check: data['user']['role']
        final String role = (data['user']?['role'] ?? 'customer').toString().toLowerCase();

        if (mounted) {
          // 3. Navigate to Dashboard
          Navigator.pushReplacementNamed(
              context,
              AppRoutes.app,
              arguments: role
          );
        }
      } else {
        final error = jsonDecode(response.body);
        _showError(error['detail'] ?? "Invalid credentials");
      }
    } catch (e) {
      _showError("Connection error: Ensure Django is running.");
      print("Login Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    // UI remains largely the same, but we removed Supabase logic
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/logo1.png', height: 100),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputStyle("Email or Username", Icons.person_outline),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputStyle("Password", Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("OR", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                SocialAuthButtons(
                  onGoogle: () => print("Social login tied to Django coming soon"),
                  onFacebook: () => {},
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => showSelectRoleDialog(context),
                  child: const Text("Don't have an account? Sign Up",
                      style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF0EA5E9)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF0EA5E9))),
    );
  }
}