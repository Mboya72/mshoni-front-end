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
    Widget page;

    switch (settings.name) {
      case onboarding:
        page = const OnboardingScreen();
        break;

      case signup:
        final role = settings.arguments as String? ?? 'customer';
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(role: role),
        );

      case login:
        page = const SignInScreen();
        break;

      case app:
        final roleString = settings.arguments as String? ?? 'customer';

        // Convert String → UserRole enum
        final UserRole role =
        roleString == 'tailor' ? UserRole.tailor : UserRole.customer;

        return MaterialPageRoute(
          builder: (_) => DynamicNavBar(role: role),
        );

      default:
        page = const Scaffold(
          body: Center(child: Text('Route not found')),
        );
        break;
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        final fadeTween =
        Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));

        final scaleTween =
        Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

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
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
