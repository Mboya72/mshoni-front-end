import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_service.dart';
import '../../../core/network/api_config.dart';

/// Data model for Customer spending and project counts
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
      totalInvestment: (json['total_investment'] ?? 0).toDouble(),
      monthlySpent: (json['monthly_spent'] ?? 0).toDouble(),
      lastMonthSpent: (json['last_month_spent'] ?? 0).toDouble(),
      activeProjects: json['active_projects_count'] ?? 0,
      completedProjects: json['completed_projects_count'] ?? 0,
      avgPerOrder: json['avg_order_value'] ?? "KSh 0",
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
          _userName = userData?['first_name'] ?? userData?['username'] ?? "Customer";
        });
        await _fetchCustomerData(token);
      }
    } catch (e) {
      debugPrint("❌ Customer Init Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCustomerData(String token) async {
    try {
      // Fetching stats from our Django 'customers/stats/' endpoint
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/projects/customer-stats/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _stats = CustomerStats.fromJson(jsonDecode(response.body));
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load customer stats");
      }
    } catch (e) {
      debugPrint("❌ Stats Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? "${s[0].toUpperCase()}${s.substring(1)}" : s;

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
          onRefresh: () async {
            final token = await _authService.getAccessToken();
            if (token != null) await _fetchCustomerData(token);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
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
                // These would eventually be mapped from a 'RecentProjects' list
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
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=customer'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold)),
            Text("${_capitalize(_userName)} 👋", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        _buildTopIcon(Icons.notifications_none, const Color(0xFF0EA5E9)),
      ],
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      childAspectRatio: 1.05,
      children: [
        _StatGridCard(label: "Active Projects", value: _stats.activeProjects.toString().padLeft(2, '0'), icon: Icons.architecture, color: const Color(0xFF0284C7)),
        _StatGridCard(label: "Completed", value: _stats.completedProjects.toString().padLeft(2, '0'), icon: Icons.verified_outlined, color: const Color(0xFF10B981)),
        _StatGridCard(label: "Avg. per Order", value: _stats.avgPerOrder, icon: Icons.analytics_outlined, color: const Color(0xFF8B5CF6)),
        _StatGridCard(label: "Pending Pay", value: "02", icon: Icons.hourglass_empty, color: const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildTopIcon(IconData icon, Color color) {
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
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
        gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)]),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total App Investment", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("KSh ${stats.totalInvestment.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(22)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroStat("Monthly Spent", "KSh ${stats.monthlySpent.toStringAsFixed(0)}"),
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
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}