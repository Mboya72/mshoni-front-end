import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

Future<void> showSelectRoleDialog(BuildContext context) async {
  final selectedRole = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Sign up as',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 'tailor');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tailor'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 'customer');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Customer'),
          ),
        ],
      ),
    ),
  );

  // Navigate to signup screen if a role is selected
  if (selectedRole != null) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.signup,
      arguments: selectedRole,
    );
  }
}
