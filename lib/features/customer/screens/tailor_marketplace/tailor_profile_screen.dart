import 'package:flutter/material.dart';
import 'dart:ui';

class TailorProfileScreen extends StatefulWidget {
  const TailorProfileScreen({super.key});

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> {
  // Brand Palette
  static const Color accentBlue = Color(0xFF4B84F1);
  static const Color primaryTeal = Color(0xFF0D47A1);
  static const Color lightTealBg = Color(0xFFE1F5FE);
  static const Color textMain = Color(0xFF1A1D21);
  static const Color textGrey = Colors.grey;
  static const Color glassColor = Color(0x33FFFFFF);

  // State
  DateTime selectedDate = DateTime(2025, 1, 24);
  String selectedService = "Bespoke Suit";

  final List<Map<String, dynamic>> services = [
    {"name": "Bespoke Suit", "icon": Icons.accessibility_new, "price": "\$450+"},
    {"name": "Alterations", "icon": Icons.content_cut, "price": "\$20+"},
    {"name": "Traditional", "icon": Icons.checkroom, "price": "\$150+"},
    {"name": "Wedding", "icon": Icons.favorite_border, "price": "\$600+"},
  ];

  final List<String> projectImages = [
    'https://images.unsplash.com/photo-1593033581491-04621c99195d?w=500',
    'https://images.unsplash.com/photo-1598454444233-9df33624449c?w=500',
    'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500',
    'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=500',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentBlue,
      body: CustomScrollView(
        slivers: [
          // 1. BLURRY PROFILE HEADER
          SliverToBoxAdapter(child: _buildBlurryHeader()),

          // 2. MAIN CONTENT CARD
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPastProjectsGallery(),
                    _buildDateSelector(),
                    _buildServiceSelector(),
                    _buildServiceDescription(),
                    _buildBookingButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HEADER WIDGETS ---

  Widget _buildBlurryHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
      decoration: const BoxDecoration(color: glassColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topIconButton(Icons.arrow_back, () => Navigator.pop(context)),
              _topIconButton(Icons.favorite_outline, () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildProfileMainInfo(),
          const SizedBox(height: 30),
          _buildActionButtons(),
          const SizedBox(height: 30),
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildProfileMainInfo() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Center(child: Icon(Icons.person, color: Colors.white, size: 40)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text("4.6", style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text("John Master Artisan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Expert Tailor • 12 Years Exp", style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  // --- CONTENT WIDGETS ---

  Widget _buildPastProjectsGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text("Past Projects & Proof", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: projectImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: NetworkImage(projectImages[index]), fit: BoxFit.cover),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: const Icon(Icons.verified, size: 14, color: accentBlue),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime date = DateTime(2025, 1, 22 + index);
                bool isSelected = date.day == selectedDate.day;
                return GestureDetector(
                  onTap: () => setState(() => selectedDate = date),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? accentBlue : const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(date.day.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : textMain)),
                        Text("Day", style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : textGrey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Offered Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.5),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final s = services[index];
              bool isSelected = selectedService == s['name'];
              return GestureDetector(
                onTap: () => setState(() => selectedService = s['name']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? accentBlue.withOpacity(0.1) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isSelected ? accentBlue : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(s['icon'], color: isSelected ? accentBlue : textGrey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(s['name'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? accentBlue : textMain)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDescription() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(15)),
        child: Text(
          "You have selected $selectedService. This service includes a full fitting and style consultation.",
          style: const TextStyle(fontSize: 12, color: textGrey, height: 1.5),
        ),
      ),
    );
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryTeal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text("Book Appointment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- HELPER UI ---

  Widget _topIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _glassAction("Contact", Icons.message),
        _glassAction("Share", Icons.share),
        _glassAction("Review", Icons.star_border),
      ],
    );
  }

  Widget _glassAction(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Icon(icon, color: Colors.white, size: 16), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))]),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [Text("8 yrs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Exp", style: TextStyle(color: Colors.white70, fontSize: 10))]),
          Column(children: [Text("1.2k", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Works", style: TextStyle(color: Colors.white70, fontSize: 10))]),
          Column(children: [Text("4.9", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Rating", style: TextStyle(color: Colors.white70, fontSize: 10))]),
        ],
      ),
    );
  }
}
