import 'package:flutter/material.dart';

class CustomerTailorsScreen extends StatelessWidget {
  const CustomerTailorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Your Premium Palette
    const Color scaffoldBg = Color(0xFFE9EEF5);
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with Gradient and Search
            _buildGradientHeader(context, accentBlue, scaffoldBg),

            const SizedBox(height: 24),

            // 2. Horizontal Categories (Icon Circles)
            _buildCategorySection(textMain, accentBlue),

            const SizedBox(height: 32),

            // 3. "Near on you" Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Near on you",
                    style: TextStyle(
                      color: textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(color: accentBlue.withOpacity(0.8)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Horizontal Tailor Cards
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildHorizontalTailorCard(textMain, accentBlue);
                },
              ),
            ),

            // Extra padding for bottom navigation
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- UI SECTIONS ---

  Widget _buildGradientHeader(BuildContext context, Color accent, Color bg) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("My Location", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 4),
                  Text("Pietersburg, St", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 25),
          TextField(
            decoration: InputDecoration(
              hintText: "Search tailor here...",
              hintStyle: const TextStyle(color: Colors.black26),
              prefixIcon: const Icon(Icons.search, color: Colors.black26),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Color textMain, Color accent) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Suits', 'icon': Icons.accessibility_new},
      {'name': 'Alteration', 'icon': Icons.content_cut},
      {'name': 'Traditional', 'icon': Icons.dry_cleaning},
      {'name': 'Luxury', 'icon': Icons.diamond},
      {'name': 'More', 'icon': Icons.grid_view_rounded},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Icon(categories[index]['icon'], color: accent, size: 24),
                ),
                const SizedBox(height: 8),
                Text(categories[index]['name'], style: TextStyle(color: textMain, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalTailorCard(Color textMain, Color accent) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1594932224828-b4b059b6f68e?w=500&q=80',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.favorite_border, color: accent, size: 18),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Savile Row Master",
                        style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text("4.9", style: TextStyle(color: textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                // Show the primary garment specialty
                const Text("Custom Suits • Blazer", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Changed from /Hr to /Garment or specific price
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "\$120",
                              style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const TextSpan(
                              text: " /garment",
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.normal)
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.grey, size: 14),
                        Text(" 2.4 km", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}