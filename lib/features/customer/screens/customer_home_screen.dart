import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- SKY BLUE PALETTE ---
    const Color scaffoldBg = Color(0xFFF0F7FF); // Very light sky tint
    const Color textMain = Color(0xFF1A1D21);
    const Color skyBluePrimary = Color(0xFF0EA5E9); // Bright Sky Blue
    const Color skyBlueDark = Color(0xFF0369A1);    // Deep Sky Blue
    const Color softBlueBg = Color(0xFFE0F2FE);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark icons for light sky bg
        statusBarBrightness: Brightness.light,    // For iOS
      ),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
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
                children: [
                  const Text("Welcome back,",
                      style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text("Elvindio 👋",
                      style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildTopIcon(Icons.notifications_none, skyBluePrimary),
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 120, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Spending Insights",
                    style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // Hero Card with Sky Blue Gradient
                const _FinancialHeroCard(
                    primaryColor: skyBluePrimary,
                    secondaryColor: skyBlueDark
                ),

                const SizedBox(height: 30),

                const Text("Project Progress",
                    style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.05,
                  children: const [
                    _StatGridCard(
                      label: "Active Projects",
                      value: "04",
                      icon: Icons.architecture,
                      color: Color(0xFF0284C7), // Sky Blue
                      trend: "In progress",
                    ),
                    _StatGridCard(
                      label: "Completed",
                      value: "12",
                      icon: Icons.verified_outlined,
                      color: Color(0xFF10B981), // Emerald
                      trend: "+2 this week",
                    ),
                    _StatGridCard(
                      label: "Avg. per Order",
                      value: "KSh 15k",
                      icon: Icons.analytics_outlined,
                      color: Color(0xFF8B5CF6), // Purple
                      trend: "Optimal",
                    ),
                    _StatGridCard(
                      label: "Pending",
                      value: "02",
                      icon: Icons.hourglass_empty,
                      color: Color(0xFFF59E0B), // Amber
                      trend: "Attention",
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text("Recent Activity",
                    style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildOrderTile("Wedding Suit", "Tailoring Phase", 0.75, skyBluePrimary),
                _buildOrderTile("Office Blazer", "Quality Check", 0.90, const Color(0xFF10B981)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }

  Widget _buildOrderTile(String title, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 45,
                width: 45,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  color: color,
                  backgroundColor: color.withOpacity(0.1),
                ),
              ),
              Text("${(progress * 100).toInt()}%",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1D21))),
              Text(status, style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 16),
        ],
      ),
    );
  }
}

class _FinancialHeroCard extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const _FinancialHeroCard({required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total App Investment", style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("KSh 142,240",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroStat("Monthly Spent", "KSh 12,450"),
                Container(width: 1, height: 30, color: Colors.white24),
                _heroStat("Last Month", "KSh 18,200"),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.auto_graph, size: 18, color: Color(0xFF0EA5E9)),
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
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _StatGridCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;

  const _StatGridCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              if (trend != null)
                Text(
                  trend!,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1D21),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}