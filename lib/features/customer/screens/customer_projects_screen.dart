import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomerProjectsScreen extends StatelessWidget {
  const CustomerProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local colors matching your aesthetic
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "My Projects",
            style: TextStyle(color: textMain, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: accentBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: accentBlue,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectList(isActive: true),
            _buildProjectList(isActive: false),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList({required bool isActive}) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), // Clears CurvedNavBar
      itemCount: isActive ? 3 : 5,
      itemBuilder: (context, index) {
        return _ProjectCard(
          title: isActive ? "Custom Wedding Suit" : "Black Office Blazer",
          tailor: "Savile Row Master",
          progress: isActive ? 0.65 : 1.0,
          status: isActive ? "Tailoring Phase" : "Delivered",
          date: isActive ? "Due Oct 12" : "Completed Aug 05",
          accentColor: isActive ? const Color(0xFF4B84F1) : const Color(0xFF2ECC71),
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title, tailor, status, date;
  final double progress;
  final Color accentColor;

  const _ProjectCard({
    required this.title,
    required this.tailor,
    required this.status,
    required this.date,
    required this.progress,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Tailor: $tailor",
                      style: const TextStyle(color: Colors.black45, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: accentColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.black38, fontSize: 12)),
              Row(
                children: [
                  const Text("View Details",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: accentColor),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}