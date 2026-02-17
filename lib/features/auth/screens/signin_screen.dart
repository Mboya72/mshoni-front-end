import 'package:flutter/material.dart';
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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo1.png', // <-- Your PNG logo here
                      height: 100,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Title
                  Text(
                    "Welcome back",
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue",
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

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
                      focusedBorder: _roundedBorder(Colors.blue),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: _roundedBorder(),
                      enabledBorder: _roundedBorder(),
                      focusedBorder: _roundedBorder(Colors.blue),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                    validator: _required,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: forgot password
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Sign in"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Social Auth Buttons
                  SocialAuthButtons(
                    onGoogle: _signInWithGoogle,
                    onFacebook: _signInWithFacebook,
                  ),

                  const SizedBox(height: 16),

                  /// Sign Up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {
                          showSelectRoleDialog(context);
                        },
                        child: const Text("Sign up"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) {
      return "Required field";
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.app,
      );
    }
  }

  void _signInWithGoogle() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.app,
    );
  }

  void _signInWithFacebook() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.app,
    );
  }
}
