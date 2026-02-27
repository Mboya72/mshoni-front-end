import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TailorHomeScreen extends StatelessWidget {
  const TailorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color scaffoldBg = Color(0xFFF0F7FF);
    const Color textMain = Color(0xFF1A1D21);
    const Color skyBluePrimary = Color(0xFF0EA5E9);
    const Color skyBlueDark = Color(0xFF0369A1);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
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
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=tailormaster'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Workshop Mode,",
                      style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text("Master Elvin 🧵",
                      style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: _buildTopIcon(Icons.inventory_2_outlined, skyBluePrimary),
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
                const Text("Business Revenue",
                    style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // Hero Card: Revenue focused
                const _TailorHeroCard(
                    primaryColor: skyBluePrimary,
                    secondaryColor: skyBlueDark
                ),

                const SizedBox(height: 30),

                const Text("Workshop Queue",
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
                      label: "Pending Cuts",
                      value: "08",
                      icon: Icons.content_cut,
                      color: Color(0xFF0284C7),
                      trend: "Due Today",
                    ),
                    _StatGridCard(
                      label: "To be Sewn",
                      value: "14",
                      icon: Icons.checkroom,
                      color: Color(0xFF10B981),
                      trend: "Priority",
                    ),
                    _StatGridCard(
                      label: "Fittings",
                      value: "05",
                      icon: Icons.accessibility_new,
                      color: Color(0xFF8B5CF6),
                      trend: "Scheduled",
                    ),
                    _StatGridCard(
                      label: "Ready for Pickup",
                      value: "11",
                      icon: Icons.local_shipping_outlined,
                      color: Color(0xFFF59E0B),
                      trend: "Notify",
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text("Upcoming Deadlines",
                    style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildOrderTile("Client: James Omari", "Full Tuxedo • Due Tomorrow", 0.40, skyBluePrimary),
                _buildOrderTile("Client: Sarah W.", "Evening Gown • Due 3rd Mar", 0.85, const Color(0xFF10B981)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: skyBluePrimary,
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
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
              Icon(Icons.timer_outlined, size: 14, color: color),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1D21))),
                Text(status, style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black12, size: 20),
        ],
      ),
    );
  }
}

class _TailorHeroCard extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const _TailorHeroCard({required this.primaryColor, required this.secondaryColor});

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
          const Text("Total Workshop Revenue", style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("KSh 385,600",
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
                _heroStat("Expected Today", "KSh 42,000"),
                Container(width: 1, height: 30, color: Colors.white24),
                _heroStat("Orders", "24 Active"),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.insights, size: 18, color: Color(0xFF0EA5E9)),
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