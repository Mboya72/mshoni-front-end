import 'package:flutter/material.dart';
import 'package:mshoni/features/nav/nav_bar.dart';
import 'package:mshoni/features/onboarding/screens/onboarding_screen.dart';
import 'package:mshoni/features/auth/screens/signup_screen.dart';
import 'package:mshoni/features/auth/screens/signin_screen.dart';

class AppRoutes {
  static const onboarding = '/';
  static const signup = '/signup';
  static const login = '/login';
  static const app = '/app';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 1. Helper to build the target page
    Widget getPage() {
      switch (settings.name) {
        case onboarding:
          return const OnboardingScreen();

        case signup:
        // Casting safely and ensuring a default for the Tailor/Customer logic
          final role = settings.arguments as String? ?? 'customer';
          return SignUpScreen(role: role);

        case login:
          return const SignInScreen();

        case app:
        // 1. Extract arguments as a Map
          final args = settings.arguments as Map<String, dynamic>? ?? {};

          // 2. Safely get the role string and token
          final String rawRole = (args['role'] ?? 'customer').toString().toLowerCase();
          final String token = args['token'] ?? ''; // Extract the token here

          // 3. Map backend string to Flutter Enum
          UserRole role;
          if (rawRole == 'tailor') {
            role = UserRole.tailor;
          } else {
            role = UserRole.customer;
          }

          // 4. FIX: Pass both role and token to the DynamicNavBar
          return DynamicNavBar(
            role: role,
            token: token,
          );

        default:
          return const Scaffold(
            body: Center(child: Text('Route not found')),
          );
      }
    }

    // 2. Return the custom animated route
    return PageRouteBuilder(
      settings: settings, // Passes the name and arguments to the destination
      pageBuilder: (context, animation, secondaryAnimation) => getPage(),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      // Fix: Ensures the background doesn't vanish during the slide
      opaque: true,
      barrierDismissible: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from Right to Left
        final slideTween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        // Fade In
        final fadeTween = Tween<double>(
            begin: 0.0,
            end: 1.0
        ).chain(CurveTween(curve: Curves.easeIn));

        // Subtle Scale Up
        final scaleTween = Tween<double>(
            begin: 0.95,
            end: 1.0
        ).chain(CurveTween(curve: Curves.easeOut));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: ScaleTransition(
              scale: animation.drive(scaleTween),
              child: child,
            ),
          ),
        );
      },
    );
  }
}