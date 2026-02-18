import 'package:flutter/material.dart';
import 'package:mshoni/features/nav/nav_bar.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicNavBar(role: UserRole.customer);
  }
}
