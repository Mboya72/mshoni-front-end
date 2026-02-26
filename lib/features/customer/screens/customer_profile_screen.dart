import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      // Removed 'const' here because AssetImage is evaluated at runtime
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Center(
              child: CircleAvatar(
                radius: 50, // Set a size so it's visible
                // backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}