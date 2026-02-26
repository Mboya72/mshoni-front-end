import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Your Premium Palette
    const Color scaffoldBg = Color(0xFFF8F9FB);
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildUserHeader(textMain, accentBlue),
            const SizedBox(height: 30),

            // Standard Settings
            _buildSettingsGroup(
              title: "Preferences",
              children: [
                _settingsTile(Icons.person_outline, "Account Details", textMain),
                _settingsTile(Icons.straighten, "My Measurements", textMain),
                _settingsTile(Icons.notifications_none, "Notifications", textMain),
              ],
            ),

            const SizedBox(height: 30),

            // --- USER PRO PLAN PRICING SECTION ---
            _buildUserProPlanCard(accentBlue),

            const SizedBox(height: 30),

            // Log Out
            TextButton(
              onPressed: () {},
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 100), // Clearance for your CurvedNavBar
          ],
        ),
      ),
    );
  }

  Widget _buildUserProPlanCard(Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "User Pro Plan",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Icon(Icons.verified, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "• Free shipping on all garments\n• Priority booking with top tailors\n• Exclusive 15% discount on alterations",
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Only", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "\$12.99",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        TextSpan(
                          text: "/mo",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: const Text("Get Pro", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(Color textMain, Color accent) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: accent.withOpacity(0.1),
          child: Icon(Icons.person_rounded, color: accent, size: 40),
        ),
        const SizedBox(height: 12),
        Text("Elvindio Pratama", style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20)),
        const Text("Standard Member", style: TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String label, Color textMain) {
    return ListTile(
      leading: Icon(icon, color: textMain.withOpacity(0.6), size: 22),
      title: Text(label, style: TextStyle(color: textMain, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }
}