import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Add this
import '../widgets/social_auth_buttons.dart';
import './select_role_screen.dart';
import '../../../core/routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false; // 2. Add loading state

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 3. Manual Email/Password Sign In
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.session != null) {
          if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.app);
        }
      } on AuthException catch (e) {
        _showError(e.message);
      } catch (e) {
        _showError("An unexpected error occurred");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // 4. Social Sign In (OAuth)
  Future<void> _handleSocialSignIn(OAuthProvider provider) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
      // The onAuthStateChange listener in main.dart handles navigation
    } catch (e) {
      _showError("Social login failed");
    }
  }

  void _signInWithGoogle() => _handleSocialSignIn(OAuthProvider.google);
  void _signInWithFacebook() => _handleSocialSignIn(OAuthProvider.facebook);

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

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
        child: Stack( // 5. Wrap in Stack for Loading Overlay
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Image.asset(
                          'assets/images/logo1.png',
                          height: 100,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text("Welcome back", style: textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text("Sign in to continue", style: textTheme.bodyMedium),
                      const SizedBox(height: 32),

                      /// Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email address",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: _roundedBorder(),
                          enabledBorder: _roundedBorder(),
                        ),
                        validator: _required,
                      ),
                      const SizedBox(height: 16),

                      /// Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: _roundedBorder(),
                          enabledBorder: _roundedBorder(),
                        ),
                        validator: _required,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {/* TODO: Forgot Password */},
                          child: const Text("Forgot password?"),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Sign in"),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SocialAuthButtons(
                        onGoogle: _signInWithGoogle,
                        onFacebook: _signInWithFacebook,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?"),
                          TextButton(
                            onPressed: () => showSelectRoleDialog(context),
                            child: const Text("Sign up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) return "Required field";
    return null;
  }
}