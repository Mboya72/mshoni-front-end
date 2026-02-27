import 'package:flutter/material.dart';

// --- SKY BLUE PREMIUM PALETTE ---
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyBlueDark = Color(0xFF0369A1);
const Color textMain = Color(0xFF1A1D21);
const Color emeraldSuccess = Color(0xFF10B981); // New "Finished" color

class ProjectData {
  final String clientName, garmentType, deadline, stage;
  final double progress;
  final Color stageColor;
  final bool isFinished;

  ProjectData({
    required this.clientName,
    required this.garmentType,
    required this.deadline,
    required this.stage,
    required this.progress,
    required this.stageColor,
    this.isFinished = false,
  });
}

class TailorProjectsScreen extends StatefulWidget {
  const TailorProjectsScreen({super.key});

  @override
  State<TailorProjectsScreen> createState() => _TailorProjectsScreenState();
}

class _TailorProjectsScreenState extends State<TailorProjectsScreen> {
  String activeFilter = "All";

  // Updated Data with Completed Projects
  final List<ProjectData> projects = [
    ProjectData(
        clientName: "James Omari",
        garmentType: "3-Piece Wedding Suit",
        deadline: "Tomorrow",
        stage: "Sewing",
        progress: 0.85,
        stageColor: Color(0xFF8B5CF6)
    ),
    ProjectData(
        clientName: "Hon. Mutua",
        garmentType: "Official Safari Suit",
        deadline: "Mar 10",
        stage: "Fitting",
        progress: 0.60,
        stageColor: Color(0xFFF59E0B)
    ),
    // --- COMPLETED PROJECT ---
    ProjectData(
        clientName: "Grace Nekesa",
        garmentType: "Ankara Flare Dress",
        deadline: "Finished",
        stage: "Completed",
        progress: 1.0,
        isFinished: true,
        stageColor: emeraldSuccess
    ),
    ProjectData(
        clientName: "Peter Parker",
        garmentType: "Custom Spandex Suit",
        deadline: "Finished",
        stage: "Completed",
        progress: 1.0,
        isFinished: true,
        stageColor: emeraldSuccess
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: skyScaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: skyScaffoldBg,
        elevation: 0,
        title: const Text(
          "Project Tracker",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Column(
        children: [
          // --- UPDATED FILTER CHIPS ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Cutting"),
                _buildFilterChip("Sewing"),
                _buildFilterChip("Fitting"),
                _buildFilterChip("Completed"), // New Tab
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                if (activeFilter != "All" && project.stage != activeFilter) {
                  return const SizedBox.shrink();
                }
                return _ProjectCard(project: project);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => activeFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? (label == "Completed" ? emeraldSuccess : skyBluePrimary) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectData project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: project.isFinished ? Border.all(color: emeraldSuccess.withOpacity(0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: skyBluePrimary.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
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
                  Text(project.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(project.garmentType, style: const TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              // Success or Stage Icon
              Icon(
                project.isFinished ? Icons.check_circle : Icons.pending_actions,
                color: project.stageColor,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(project.isFinished ? "Ready for Pickup" : "Completion Progress",
                  style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${(project.progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 8,
              backgroundColor: skyScaffoldBg,
              color: project.stageColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                  project.isFinished ? Icons.celebration : Icons.calendar_today_outlined,
                  size: 14,
                  color: project.isFinished ? emeraldSuccess : Colors.redAccent
              ),
              const SizedBox(width: 6),
              Text(
                project.isFinished ? "Completed successfully!" : "Deadline: ${project.deadline}",
                style: TextStyle(
                    color: project.isFinished ? emeraldSuccess : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),
              const Spacer(),
              if (project.isFinished)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldSuccess,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text("Notify Client", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                )
              else
                const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}