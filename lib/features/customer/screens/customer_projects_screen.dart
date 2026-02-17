import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomerProjectsScreen extends StatelessWidget {
  const CustomerProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.work,
              size: 80,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Customer Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Here you can view your ongoing and completed projects.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
