import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this
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
  bool _obscurePassword = true;
  bool _isLoading = false; // Added to handle loading state

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 1. Social Auth Logic using Supabase
  Future<void> _handleSocialAuth(OAuthProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        provider,
        // Ensure this deep link is registered in your Google/Meta consoles
        redirectTo: 'io.supabase.flutter://login-callback',
        // We pass the role to the backend via queryParams
        queryParams: {'role': widget.role.toLowerCase()},
      );
      // Note: No need for Navigator.push here. Supabase will handle the
      // redirect back to the app, which you should catch in your main.dart or a listener.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signUpWithGoogle() => _handleSocialAuth(OAuthProvider.google);

  void _signUpWithFacebook() => _handleSocialAuth(OAuthProvider.facebook);

  // 2. Manual Email/Password Sign Up Logic
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          data: {
            'full_name': _nameController.text.trim(),
            'role': widget.role.toLowerCase(), // This saves role in auth.users.raw_user_meta_data
          },
        );

        if (response.user != null) {
          // Success! Navigate to the main app
          Navigator.pushReplacementNamed(context, AppRoutes.app);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign up failed: ${e.toString()}")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
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
        child: Stack( // Added Stack for loading overlay
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/images/logo1.png',
                      height: 100,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Create account",
                      style: textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up as ${widget.role[0].toUpperCase()}${widget.role.substring(1)}",
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Full name",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: _roundedBorder(),
                              enabledBorder: _roundedBorder(),
                              focusedBorder: _roundedBorder(Colors.blue),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email address",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: _roundedBorder(),
                              enabledBorder: _roundedBorder(),
                              focusedBorder: _roundedBorder(Colors.blue),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                              ),
                              border: _roundedBorder(),
                              enabledBorder: _roundedBorder(),
                              focusedBorder: _roundedBorder(Colors.blue),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text("Sign up"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SocialAuthButtons(
                      onGoogle: _signUpWithGoogle,
                      onFacebook: _signUpWithFacebook,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
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