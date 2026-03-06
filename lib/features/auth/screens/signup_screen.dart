import 'package:flutter/material.dart';
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
  final AuthService _authService = AuthService(); // Ensure this matches your Singleton

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

  /// --- GOOGLE SIGN-IN ---
  Future<void> _handleSocialAuth(String provider) async {
    if (provider == 'google') {
      setState(() => _isLoading = true);
      try {
        // Pass the role (tailor/customer) to the Google exchange
        final success = await _authService.signInWithGoogle(widget.role);

        if (mounted) {
          if (success) {
            Navigator.pushReplacementNamed(
                context,
                AppRoutes.app,
                arguments: widget.role.toLowerCase()
            );
          } else {
            _showError("Google Sign-In failed. Check your connection.");
          }
        }
      } catch (e) {
        _showError("Google Auth Error: $e");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      _showError("Facebook Sign-In is not yet configured.");
    }
  }

  /// --- MANUAL DJANGO SIGN UP ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final String fullInput = _nameController.text.trim();
      final List<String> nameParts = fullInput.split(' ');

      // Clean parsing for Django's expected fields
      final String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'User';

      final bool success = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: firstName,
        lastName: lastName,
        role: widget.role.toLowerCase(),
      );

      if (mounted) {
        if (success) {
          // If successful, the AuthService has already saved the session
          Navigator.pushReplacementNamed(
              context,
              AppRoutes.app,
              arguments: widget.role.toLowerCase()
          );
        } else {
          _showError("Sign up failed. This email might already be registered.");
        }
      }
    } catch (e) {
      if (mounted) _showError("Backend Error: Could not reach Mshoni servers.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Image.asset('assets/images/logo1.png', height: 80),
                  const SizedBox(height: 32),
                  Text("Create account", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Joining Mshoni as a ${widget.role}", style: textTheme.bodyLarge?.copyWith(color: Colors.black54)),
                  const SizedBox(height: 32),

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
                              backgroundColor: const Color(0xFF0EA5E9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _isLoading ? null : _submit,
                            child: const Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("OR", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SocialAuthButtons(
                    onGoogle: () => _handleSocialAuth("google"),
                    onFacebook: () => _handleSocialAuth("facebook"),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                        child: const Text("Sign in", style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // UI Overlay for Loading
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator(color: Color(0xFF0EA5E9))),
              ),
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
        prefixIcon: Icon(icon, color: const Color(0xFF0EA5E9)),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ) : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF0EA5E9))),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required field" : null,
    );
  }
}