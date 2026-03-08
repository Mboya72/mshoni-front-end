import 'package:flutter/material.dart';
import 'package:mshoni/features/nav/nav_bar.dart';

class CustomerHomeScreen extends StatelessWidget {
  final String token; // 1. Add token field
  const CustomerHomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    // 2. Pass the token to satisfy the required parameter
    return DynamicNavBar(
      role: UserRole.customer,
      token: token,
    );
  }
}