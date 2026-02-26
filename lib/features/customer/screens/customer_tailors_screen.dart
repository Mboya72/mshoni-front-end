import 'package:flutter/material.dart';

class CustomerTailorsScreen extends StatelessWidget {
  const CustomerTailorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Palette
    const Color scaffoldBg = Color(0xFFE9EEF5);
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);
    const Color emeraldGreen = Color(0xFF2ECC71);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Find Tailors",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: textMain), // Filter icon
            onPressed: () => _showFilterSheet(context, accentBlue),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by style or name...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: scaffoldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // 2. Horizontal Quick Filters
          Container(
            height: 60,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _filterChip("All", true, accentBlue),
                _filterChip("Suits", false, accentBlue),
                _filterChip("Traditional", false, accentBlue),
                _filterChip("Alterations", false, accentBlue),
                _filterChip("Luxury", false, accentBlue),
              ],
            ),
          ),

          // 3. Tailor Results List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Extra bottom padding for CurvedNavBar
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildTailorCard(context, textMain, accentBlue, emeraldGreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _filterChip(String label, bool isSelected, Color activeColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : const Color(0xFFF3F6F9),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTailorCard(BuildContext context, Color textMain, Color accent, Color emerald) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=tailor'),
            ),
            title: Text("Savile Row Master",
                style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                const Text("4.9 (120 reviews)", style: TextStyle(fontSize: 12)),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: emerald.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text("Active", style: TextStyle(color: emerald, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Suits • Wedding • Tuxedos", style: TextStyle(color: Colors.grey, fontSize: 13)),
                TextButton(
                  onPressed: () {},
                  child: Text("View Profile", style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, Color accent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Advanced Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Price Range"),
            RangeSlider(values: const RangeValues(20, 80), onChanged: (val) {}, min: 0, max: 100),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Apply Filters", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}