import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_service.dart';
import '../../../core/network/api_config.dart';

class CustomerStats {
  final double totalInvestment;
  final double monthlySpent;
  final double lastMonthSpent;
  final int activeProjects;
  final int completedProjects;
  final String avgPerOrder;

  CustomerStats({
    this.totalInvestment = 0.0,
    this.monthlySpent = 0.0,
    this.lastMonthSpent = 0.0,
    this.activeProjects = 0,
    this.completedProjects = 0,
    this.avgPerOrder = "KSh 0",
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) {
    return CustomerStats(
      // Improved null safety and type casting
      totalInvestment: double.tryParse(json['total_investment']?.toString() ?? '0') ?? 0.0,
      monthlySpent: double.tryParse(json['monthly_spent']?.toString() ?? '0') ?? 0.0,
      lastMonthSpent: double.tryParse(json['last_month_spent']?.toString() ?? '0') ?? 0.0,
      activeProjects: json['active_projects_count'] ?? 0,
      completedProjects: json['completed_projects_count'] ?? 0,
      avgPerOrder: json['avg_order_value']?.toString() ?? "KSh 0",
    );
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final AuthService _authService = AuthService();
  String _userName = "Customer";
  bool _isLoading = true;
  CustomerStats _stats = CustomerStats();

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

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
          // Robustly check for name in the profile
          _userName = userData?['first_name'] ?? userData?['username'] ?? "Customer";
        });
        await _fetchCustomerData(token);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCustomerData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/projects/customer-stats/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _stats = CustomerStats.fromJson(jsonDecode(response.body));
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Stats Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color skyBluePrimary = Color(0xFF0EA5E9);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: skyBluePrimary)),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F7FF),
        body: RefreshIndicator(
          color: skyBluePrimary,
          onRefresh: () async {
            final token = await _authService.getAccessToken();
            if (token != null) await _fetchCustomerData(token);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                const Text("Spending Insights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _FinancialHeroCard(stats: _stats),
                const SizedBox(height: 30),
                const Text("Project Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildStatGrid(),
                const SizedBox(height: 30),
                const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFF0EA5E9),
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold)),
            Text("${_userName[0].toUpperCase()}${_userName.substring(1)} 👋", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        _buildTopIcon(Icons.notifications_none),
      ],
    );
  }

  Widget _buildStatGrid() {
    // Wrap GridView in a fixed height or use shrinkWrap carefully
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1, // Adjusted for better text fitting
      children: [
        _StatGridCard(label: "Active Projects", value: _stats.activeProjects.toString().padLeft(2, '0'), icon: Icons.architecture, color: const Color(0xFF0284C7)),
        _StatGridCard(label: "Completed", value: _stats.completedProjects.toString().padLeft(2, '0'), icon: Icons.verified_outlined, color: const Color(0xFF10B981)),
        _StatGridCard(label: "Avg. per Order", value: _stats.avgPerOrder, icon: Icons.analytics_outlined, color: const Color(0xFF8B5CF6)),
        _StatGridCard(label: "Pending Pay", value: "02", icon: Icons.hourglass_empty, color: const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }

  Widget _buildOrderTile(String title, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(height: 45, width: 45, child: CircularProgressIndicator(value: progress, strokeWidth: 4, color: color, backgroundColor: color.withOpacity(0.1))),
              Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(status, style: const TextStyle(color: Colors.black45, fontSize: 12)),
          ])),
          const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 16),
        ],
      ),
    );
  }
}

class _FinancialHeroCard extends StatelessWidget {
  final CustomerStats stats;
  const _FinancialHeroCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0EA5E9).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Mshoni Investment", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("KSh ${stats.totalInvestment.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(18)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroStat("Monthly Spent", "KSh ${stats.monthlySpent.toStringAsFixed(0)}"),
                const VerticalDivider(color: Colors.white24),
                _heroStat("Last Month", "KSh ${stats.lastMonthSpent.toStringAsFixed(0)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    ]);
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          Text(label, style: const TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}