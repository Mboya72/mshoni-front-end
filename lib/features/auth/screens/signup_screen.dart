import 'package:flutter/material.dart';
import '../widgets/social_auth_buttons.dart';
import '../../../core/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  final String role; // role passed from onboarding

  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUpWithGoogle() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.app,
      arguments: widget.role, // <--- fix here
    );
  }

  void _signUpWithFacebook() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.app,
      arguments: widget.role, // <--- fix here
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
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                /// Logo
                Image.asset(
                  'assets/images/logo1.png',
                  height: 100,
                  width: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                /// Title
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

                /// Form
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
                          onPressed: _submit,
                          child: const Text("Sign up"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Social Buttons
                SocialAuthButtons(
                  onGoogle: _signUpWithGoogle,
                  onFacebook: _signUpWithFacebook,
                ),

                const SizedBox(height: 16),

                /// Already have an account
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
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) return "Required field";
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.app,
        arguments: widget.role, // <--- fix here
      );
    }
  }
}
