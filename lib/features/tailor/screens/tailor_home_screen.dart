import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class TailorHomeScreen extends StatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  State<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends State<TailorHomeScreen> {
  final AuthService _authService = AuthService();
  String _userName = "Master Tailor";
  String? _token;
  bool _isLoading = true;

  // Colors
  static const Color scaffoldBg = Color(0xFFF0F7FF);
  static const Color textMain = Color(0xFF1A1D21);
  static const Color skyBluePrimary = Color(0xFF0EA5E9);
  static const Color skyBlueDark = Color(0xFF0369A1);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getUser();
      final token = await _authService.getToken();

      // DEBUG: Verify keys in your debug console
      debugPrint("DEBUG: User Data Map content: $userData");

      if (mounted) {
        if (token == null) {
          Navigator.pushReplacementNamed(context, '/login');
          return;
        }

        setState(() {
          // Check most descriptive fields first. Falls back to username or "Master Tailor"
          _userName = userData?['full_name'] ??
              userData?['user']?['full_name'] ??
              userData?['first_name'] ??
              userData?['username'] ??
              "Master Tailor";

          _token = token;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper method for professional text formatting
  String _capitalize(String s) => s.isNotEmpty ? "${s[0].toUpperCase()}${s.substring(1)}" : s;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: scaffoldBg,
        body: Center(child: CircularProgressIndicator(color: skyBluePrimary)),
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=tailormaster'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Workshop Mode,",
                      style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(
                    "Master ${_capitalize(_userName)} 🧵",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: _buildTopIcon(Icons.inventory_2_outlined, skyBluePrimary),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Business Revenue",
                style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _TailorHeroCard(primaryColor: skyBluePrimary, secondaryColor: skyBlueDark),
            const SizedBox(height: 30),
            const Text("Workshop Queue",
                style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: skyBluePrimary,
        elevation: 4,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Icon(icon, color: Colors.black87, size: 20),
    );
  }

  Widget _buildOrderTile(String title, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  color: color,
                  backgroundColor: color.withOpacity(0.1),
                ),
              ),
              Icon(Icons.timer_outlined, size: 12, color: color),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textMain)),
                Text(status, style: const TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black12, size: 20),
        ],
      ),
    );
  }
}

// --- SUPPORTING WIDGETS ---

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
        gradient: LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Workshop Revenue", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("KSh 385,600", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statItem("Expected Today", "KSh 42k"),
                _statItem("Active Orders", "24"),
                const Icon(Icons.trending_up, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _StatGridCard extends StatelessWidget {
  final String label, value, trend;
  final IconData icon;
  final Color color;
  const _StatGridCard({required this.label, required this.value, required this.icon, required this.color, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(trend, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}