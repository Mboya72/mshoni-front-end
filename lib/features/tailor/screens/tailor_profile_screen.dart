import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- SKY BLUE PREMIUM PALETTE ---
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyBlueDark = Color(0xFF0369A1);
const Color textMain = Color(0xFF1A1D21);

class TailorProfileScreen extends StatelessWidget {
  const TailorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: skyScaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Workshop Profile",
            style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_suggest_outlined, color: textMain)
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- PROFILE HEADER ---
            _buildProfileHeader(),

            const SizedBox(height: 25),

            // --- PLAN STATUS BADGE ---
            _buildPlanStatus(),

            const SizedBox(height: 25),

            // --- STATS ROW ---
            _buildQuickStats(),

            const SizedBox(height: 35),

            // --- PRO PLAN PRICING CARD ---
            _buildProPlanCard(),

            const SizedBox(height: 30),

            // --- BUSINESS MANAGEMENT SECTION ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Workshop Management",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain)),
            ),
            const SizedBox(height: 15),
            _buildMenuTile(Icons.history, "Complete Order Archives"),
            _buildMenuTile(Icons.group_add_outlined, "Manage Workshop Assistants"),
            _buildMenuTile(Icons.account_balance_wallet_outlined, "Payout & Revenue Settings"),
            _buildMenuTile(Icons.contact_support_outlined, "Help & Masterclass Access"),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [skyBluePrimary, Colors.white]),
                boxShadow: [BoxShadow(color: skyBluePrimary.withOpacity(0.2), blurRadius: 20)],
              ),
              child: const CircleAvatar(
                radius: 54,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=tailormaster'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: skyBluePrimary,
                child: Icon(Icons.check, color: Colors.white, size: 16),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        const Text("Master Elvin J.",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain)),
        const Text("Elite Bespoke Designer • Nairobi, KE",
            style: TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPlanStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: skyBluePrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: skyBluePrimary.withOpacity(0.2)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, color: skyBluePrimary, size: 16),
          SizedBox(width: 8),
          Text("CURRENT PLAN: FREE VERSION",
              style: TextStyle(color: skyBlueDark, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("1.2k", "Deliveries"),
          _divider(),
          _statItem("4.9", "Rating"),
          _divider(),
          _statItem("8 yrs", "Expertise"),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 25, color: Colors.black12);

  Widget _statItem(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: skyBlueDark)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [skyBluePrimary, skyBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: skyBluePrimary.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TAILOR PRO PLAN",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("KSh 2,500", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              Text("/mo", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 25),
          _proFeature(Icons.bolt, "Unlimited Cloud Measurement Sync"),
          _proFeature(Icons.mp_outlined, "Direct M-Pesa Business Link"),
          _proFeature(Icons.message_outlined, "Auto-WhatsApp Status Updates"),
          _proFeature(Icons.analytics_outlined, "Advanced Revenue Insights"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: skyBlueDark,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            child: const Text("Go Pro Now", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          )
        ],
      ),
    );
  }

  Widget _proFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: ListTile(
        leading: Icon(icon, color: skyBluePrimary, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
        onTap: () {},
      ),
    );
  }
}