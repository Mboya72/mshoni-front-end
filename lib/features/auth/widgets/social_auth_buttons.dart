import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback onGoogle;
  final VoidCallback onFacebook;

  const SocialAuthButtons({
    super.key,
    required this.onGoogle,
    required this.onFacebook,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("or continue with"),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: SvgPicture.asset('assets/icons/google.svg', height: 20),
            label: const Text("Continue with Google"),
            onPressed: onGoogle,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: SvgPicture.asset('assets/icons/facebook.svg', height: 24),
            label: const Text("Continue with Facebook"),
            onPressed: onFacebook,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
