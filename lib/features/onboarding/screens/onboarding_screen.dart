import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/logo1.png',
      'title': 'Built for Tailors.',
      'subtitle': 'Trusted by Customers.',
    },
    {
      'image': 'assets/images/onboard2.png',
      'title': 'Talk to Tailors You Trust',
      'subtitle':
      'Chat, share designs, and track your tailoring work with ease.',
    },
    {
      'image': 'assets/images/onboard3.png',
      'title': 'Stay Organized & On Time',
      'subtitle':
      'Manage orders, progress, and deliveries — stress free.',
    },
  ];

  void _showRoleSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sign up as",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            /// Tailor
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.signup,
                  arguments: 'tailor',
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Tailor"),
            ),

            const SizedBox(height: 12),

            /// Customer
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.signup,
                  arguments: 'customer',
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Customer"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// PAGE VIEW
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  final isFirstPage = i == 0;

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page['image']!,
                          height: isFirstPage ? 90 : 320,
                          width: isFirstPage ? 300 : double.infinity,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),

                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: isFirstPage
                              ? textTheme.displayLarge
                              ?.copyWith(fontSize: 28)
                              : textTheme.titleLarge,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: isFirstPage
                              ? textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.onSurfaceVariant,
                          )
                              : textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _current == i ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _current == i
                        ? colors.primary
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// NEXT / CREATE ACCOUNT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _current == _pages.length - 1
                      ? _showRoleSelection
                      : () => _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  ),
                  child: Text(
                    _current == _pages.length - 1
                        ? 'Create account'
                        : 'Next',
                  ),
                ),
              ),
            ),

            /// LOGIN LINK
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
              ),
              child: Text(
                'Already have an account? Sign in',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
