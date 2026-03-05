import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_service.dart';
import '../../../core/network/api_config.dart';

/// Data model for workshop statistics
class TailorStats {
  final double totalRevenue;
  final int pendingCuts;
  final int toBeSewn;
  final int fittings;
  final int ready;

  TailorStats({
    this.totalRevenue = 0.0,
    this.pendingCuts = 0,
    this.toBeSewn = 0,
    this.fittings = 0,
    this.ready = 0,
  });

  factory TailorStats.fromJson(Map<String, dynamic> json) {
    return TailorStats(
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      pendingCuts: json['pending_cuts'] ?? 0,
      toBeSewn: json['to_be_sewn'] ?? 0,
      fittings: json['fittings'] ?? 0,
      ready: json['ready_for_pickup'] ?? 0,
    );
  }
}

class TailorHomeScreen extends StatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  State<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends State<TailorHomeScreen> {
  final AuthService _authService = AuthService();

  // State variables
  String _userName = "Master Tailor";
  String? _token;
  bool _isLoading = true;
  TailorStats _stats = TailorStats();

  // Theme Colors
  static const Color scaffoldBg = Color(0xFFF0F7FF);
  static const Color textMain = Color(0xFF1A1D21);
  static const Color skyBluePrimary = Color(0xFF0EA5E9);
  static const Color skyBlueDark = Color(0xFF0369A1);

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  /// Combined initialization: Load User -> Load Stats
  Future<void> _initDashboard() async {
    try {
      final userData = await _authService.getUserProfile();
      final token = await _authService.getAccessToken();

      if (token == null) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      if (mounted) {
        setState(() {
          _userName = userData?['first_name'] ?? userData?['username'] ?? "Master Tailor";
          _token = token;
        });
        await _fetchStats();
      }
    } catch (e) {
      debugPrint("❌ Init Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Fetch dynamic statistics from the Django backend
  Future<void> _fetchStats() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/marketplace/stats/"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _stats = TailorStats.fromJson(jsonDecode(response.body));
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load stats");
      }
    } catch (e) {
      debugPrint("❌ Stats Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _fetchStats,
        color: skyBluePrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Business Revenue", style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _TailorHeroCard(revenue: _stats.totalRevenue),
              const SizedBox(height: 30),
              const Text("Workshop Queue", style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildStatGrid(),
              const SizedBox(height: 30),
              const Text("Recent Projects", style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              // Placeholders for recent project items
              _buildOrderTile("Client: James Omari", "Full Tuxedo • Cutting", 0.40, skyBluePrimary),
              _buildOrderTile("Client: Sarah W.", "Evening Gown • Finished", 1.0, const Color(0xFF10B981)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: skyBluePrimary,
        onPressed: () => Navigator.pushNamed(context, '/add-project'),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=tailormaster'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome back,", style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${_capitalize(_userName)} 👋", style: const TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.inventory_2_outlined, color: skyBluePrimary), onPressed: () {}),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _StatGridCard(label: "Pending Cuts", value: _stats.pendingCuts.toString().padLeft(2, '0'), icon: Icons.content_cut, color: const Color(0xFF0284C7)),
        _StatGridCard(label: "To be Sewn", value: _stats.toBeSewn.toString().padLeft(2, '0'), icon: Icons.checkroom, color: const Color(0xFF10B981)),
        _StatGridCard(label: "Fittings", value: _stats.fittings.toString().padLeft(2, '0'), icon: Icons.accessibility_new, color: const Color(0xFF8B5CF6)),
        _StatGridCard(label: "Ready", value: _stats.ready.toString().padLeft(2, '0'), icon: Icons.local_shipping_outlined, color: const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildOrderTile(String title, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          SizedBox(height: 40, width: 40, child: CircularProgressIndicator(value: progress, color: color, backgroundColor: color.withOpacity(0.1), strokeWidth: 3)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(status, style: const TextStyle(color: Colors.black45, fontSize: 11)),
          ])),
          const Icon(Icons.chevron_right, color: Colors.black12),
        ],
      ),
    );
  }
}

class _TailorHeroCard extends StatelessWidget {
  final double revenue;
  const _TailorHeroCard({required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Workshop Revenue", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Text("KSh ${revenue.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Updated live from M-Pesa", style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}

class _StatGridCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatGridCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11)),
        ],
      ),
    );
  }
}