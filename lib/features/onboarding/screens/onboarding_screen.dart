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

  // Professional Sky Blue Theme Colors
  static const Color skyBluePrimary = Color(0xFF0EA5E9);
  static const Color textMain = Color(0xFF1A1D21);

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/logo1.png',
      'title': 'Built for Tailors.',
      'subtitle': 'The ultimate digital companion for the modern African tailor.',
    },
    {
      'image': 'assets/images/onboard2.png',
      'title': 'Showcase Your Craft',
      'subtitle': 'Upload your portfolio, manage measurements, and connect with new clients.',
    },
    {
      'image': 'assets/images/onboard3.png',
      'title': 'Stay Organized & On Time',
      'subtitle': 'Track project progress from cutting to delivery with real-time updates.',
    },
  ];

  void _showRoleSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            const Text(
              "Choose Your Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain),
            ),
            const SizedBox(height: 8),
            const Text(
              "Are you here to design or to be dressed?",
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
            const SizedBox(height: 32),

            /// Tailor Option
            _roleButton(
              title: "I am a Tailor",
              desc: "Manage workshop, clients & orders",
              icon: Icons.content_cut,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.signup, arguments: 'tailor');
              },
            ),

            const SizedBox(height: 16),

            /// Customer Option
            _roleButton(
              title: "I am a Customer",
              desc: "Find tailors & track my clothes",
              icon: Icons.person_search_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.signup, arguments: 'customer');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _roleButton({required String title, required String desc, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: skyBluePrimary.withOpacity(0.1),
              child: Icon(icon, color: skyBluePrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(page['image']!, height: i == 0 ? 100 : 280, fit: BoxFit.contain),
                        const SizedBox(height: 40),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textMain),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Indicators & Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8, width: _current == i ? 24 : 8,
                      decoration: BoxDecoration(color: _current == i ? skyBluePrimary : Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                    )),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _current == 2 ? _showRoleSelection : () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: skyBluePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(_current == 2 ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: const Text('Already have an account? Sign in', style: TextStyle(color: skyBluePrimary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}