import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const Color accentBlue = Color(0xFF4B84F1);
  static const Color textMain = Color(0xFF1A1D21);
  static const Color scaffoldBg = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. IMAGE HEADER
              SliverToBoxAdapter(
                child: _buildImageSection(context),
              ),

              // 2. PRODUCT DETAILS
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildBrandRow(),
                    const SizedBox(height: 12),
                    const Text(
                      "Casual Mandarin Collar Shirt",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow(),
                    const SizedBox(height: 25),
                    _buildSelectionTitle("Size"),
                    _buildSizeSelector(),
                    const SizedBox(height: 25),
                    _buildSelectionTitle("Color"),
                    _buildColorSelector(),
                    const SizedBox(height: 25),
                    _buildDescription(),
                    const SizedBox(height: 140), // Space for bottom buttons
                  ]),
                ),
              ),
            ],
          ),

          // 3. STICKY FOOTER BUTTONS
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENT METHODS ---

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 450,
          width: double.infinity,
          color: scaffoldBg,
          child: const Center(
            child: Icon(Icons.dry_cleaning, size: 200, color: Colors.blueGrey),
          ),
        ),
        // Top Buttons
        Positioned(
          top: 60,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
              _circleButton(Icons.favorite_border, () {}),
            ],
          ),
        ),
        // Image counter
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text("1/8", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: textMain),
      ),
    );
  }

  Widget _buildBrandRow() {
    return Row(
      children: [
        const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Text("H&M", style: TextStyle(fontSize: 6, color: Colors.white))),
        const SizedBox(width: 8),
        const Text("H&M", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(width: 4),
        const Icon(Icons.check_circle, color: accentBlue, size: 16),
        const Spacer(),
        const Icon(Icons.star, color: Colors.orange, size: 18),
        const SizedBox(width: 4),
        const Text("4.3", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        const Text("\$900.00", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain)),
        const SizedBox(width: 10),
        const Text("\$1,200.00", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
          child: const Text("-25%", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const Spacer(),
        const Text("10k+ Sold", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSelectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSizeSelector() {
    List<String> sizes = ["S", "M", "L", "XL"];
    return Row(
      children: sizes.map((s) => Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: s == "M" ? accentBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(s, style: TextStyle(color: s == "M" ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
      )).toList(),
    );
  }

  Widget _buildColorSelector() {
    List<Color> colors = [const Color(0xFF3B566E), Colors.grey, Colors.black, Colors.red];
    return Row(
      children: colors.map((c) => Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c == colors[0] ? accentBlue : Colors.transparent, width: 2),
        ),
        child: CircleAvatar(radius: 12, backgroundColor: c),
      )).toList(),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          "Stay stylish with this Men's Mandarin Collar Shirt. Featuring a sleek button-down design and breathable fabric, it's perfect for both casual and formal occasions.",
          style: TextStyle(color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Read More", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey), // Correct: BorderSide
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Add Cart", style: TextStyle(color: textMain, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Buy Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}