import 'package:flutter/material.dart';

class CustomerLikedScreen extends StatefulWidget {
  const CustomerLikedScreen({super.key});

  @override
  State<CustomerLikedScreen> createState() => _CustomerLikedScreenState();
}

class _CustomerLikedScreenState extends State<CustomerLikedScreen> {
  static const Color accentBlue = Color(0xFF4B84F1);
  static const Color scaffoldBg = Color(0xFFF8F9FA);
  static const Color textMain = Color(0xFF1A1D21);
  bool isClothesTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Favorites", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: textMain)),
                  Text("Items and Tailors you loved", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ),

          // Custom Toggle
          SliverToBoxAdapter(child: _buildToggle()),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: isClothesTab ? _buildLikedClothes() : _buildLikedTailors(),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            _toggleBtn("Clothes", isClothesTab),
            _toggleBtn("Tailors", !isClothesTab),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isClothesTab = label == "Clothes"),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? accentBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildLikedClothes() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container(color: scaffoldBg, width: double.infinity, child: const Icon(Icons.image, color: Colors.grey))),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Summer Blazer", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Positioned(top: 8, right: 8, child: Icon(Icons.favorite, color: Colors.red, size: 20)),
            ],
          ),
        ),
        childCount: 4,
      ),
    );
  }

  Widget _buildLikedTailors() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: const ListTile(
            leading: CircleAvatar(backgroundColor: scaffoldBg, child: Icon(Icons.person, color: accentBlue)),
            title: Text("Master Boutique", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Specialist in Embroidery"),
            trailing: Icon(Icons.favorite, color: Colors.red),
          ),
        ),
        childCount: 3,
      ),
    );
  }
}