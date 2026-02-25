import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessary for the phone's top bar colors

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Off-white/Slate color scheme
    const Color scaffoldBg = Color(0xFFE9EEF5);
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);
    const Color emeraldGreen = Color(0xFF2ECC71);

    // AnnotatedRegion fixes the phone's top status bar (battery/clock visibility)
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Makes icons dark so they show on light bg
        statusBarBrightness: Brightness.light,    // For iOS compatibility
      ),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        extendBodyBehindAppBar: true, // Content flows under the transparent AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=elvindio'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Welcome back,",
                      style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text("Elvindio 👋",
                      style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildTopIcon(Icons.notifications_none),
            ),
          ],
        ),
        body: SingleChildScrollView(
          // Top padding of 120 ensures content starts below the AppBar/Status Bar
          padding: const EdgeInsets.only(left: 20, right: 20, top: 120, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FINANCIAL SECTION ---
              const Text("Financial Journey",
                  style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const _FinancialHeroCard(),

              const SizedBox(height: 30),

              // --- STATISTICS GRID ---
              const Text("Project Progress",
                  style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: const [
                  _StatGridCard(label: "Active Projects", value: "04", icon: Icons.architecture, color: accentBlue),
                  _StatGridCard(label: "Completed", value: "12", icon: Icons.verified_outlined, color: emeraldGreen),
                  _StatGridCard(label: "Total Spent", value: "\$4.2k", icon: Icons.payments_outlined, color: Colors.orange),
                  _StatGridCard(label: "Pending", value: "02", icon: Icons.hourglass_empty, color: Colors.redAccent),
                ],
              ),

              const SizedBox(height: 30),

              // --- ACTIVITY SECTION ---
              const Text("Recent Activity",
                  style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildOrderTile("Wedding Suit", "Tailoring Phase", 0.75, accentBlue),
              _buildOrderTile("Office Blazer", "Quality Check", 0.90, emeraldGreen),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for AppBar Notification Icon
  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }

  // Helper for Recent Activity Rows
  Widget _buildOrderTile(String title, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 45, width: 45,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  color: color,
                  backgroundColor: color.withOpacity(0.1),
                ),
              ),
              Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1D21))),
              Text(status, style: const TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 16),
        ],
      ),
    );
  }
}

// --- SUB-WIDGET: FINANCIAL HERO ---
class _FinancialHeroCard extends StatelessWidget {
  const _FinancialHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B84F1), Color(0xFF2E5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B84F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Wallet Balance", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          const Text("\$1,240.00",
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroStat("Monthly Spend", "\$450"),
                Container(width: 1, height: 30, color: Colors.white24),
                _heroStat("Project Goal", "85%"),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.trending_up, size: 18, color: Color(0xFF4B84F1)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

// --- SUB-WIDGET: STATISTICS GRID CARD ---
class _StatGridCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatGridCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1D21))),
          Text(label, style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}