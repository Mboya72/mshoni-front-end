import 'package:flutter/material.dart';
// Removed Supabase import since we are using local Django only
import '../../../../core/services/auth_service.dart';
import '../widgets/social_auth_buttons.dart';
import '../../../core/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  final String role;

  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1. Social Auth (Disabled/Placeholder for now as requested)
  Future<void> _handleSocialAuth(String provider) async {
    _showError("Social Sign Up is temporarily disabled to focus on Localhost.");
  }

  // 2. Manual Email/Password Sign Up (Direct to Django)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // We now wait for the boolean success from your updated AuthService
      final bool success = await _authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        role: widget.role.toUpperCase(),
      );

      if (mounted) {
        if (success) {
          // Success: Navigate to the main app/home
          Navigator.pushReplacementNamed(context, AppRoutes.app);
        } else {
          // Failure: Likely a connection or validation error from Django
          _showError("Sign up failed. Check your connection or if the user already exists.");
        }
      }
    } catch (e) {
      if (mounted) _showError("An unexpected error occurred: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ... (Rest of your UI code remains the same, but using updated _submit) ...

  OutlineInputBorder _roundedBorder([Color color = Colors.grey]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Image.asset('assets/images/logo1.png', height: 100, width: 250),
                    const SizedBox(height: 24),
                    Text("Create account", style: textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text("Sign up as ${widget.role}", style: textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(_nameController, "Full name", Icons.person_outline),
                          const SizedBox(height: 16),
                          _buildTextField(_emailController, "Email address", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 16),
                          _buildTextField(_passwordController, "Password", Icons.lock_outline, isPassword: true),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text("Sign up"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SocialAuthButtons(
                      onGoogle: () => _handleSocialAuth("google"),
                      onFacebook: () => _handleSocialAuth("facebook"),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const Opacity(
                opacity: 0.4,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ) : null,
        border: _roundedBorder(),
        enabledBorder: _roundedBorder(),
        focusedBorder: _roundedBorder(Colors.blue),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required field" : null,
    );
  }
}