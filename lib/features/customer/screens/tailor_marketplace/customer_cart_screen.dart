import 'package:flutter/material.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  static const Color accentBlue = Color(0xFF4B84F1);
  static const Color scaffoldBg = Color(0xFFF8F9FA);
  static const Color textMain = Color(0xFF1A1D21);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Cart", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: textMain)),
                      Text("3 items ready for checkout", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ),

              // Cart Items List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildCartItem(),
                    childCount: 3,
                  ),
                ),
              ),

              // Bottom Buffer for the Checkout Panel
              const SliverPadding(padding: EdgeInsets.only(bottom: 220)),
            ],
          ),

          // Floating Checkout Summary Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCheckoutPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.dry_cleaning, color: accentBlue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Custom Slim Fit Suit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("Size: M | Blue", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("\$240.00", style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                    _buildQuantityStepper(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper() {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () {}),
          const Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add, size: 16, color: accentBlue), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow("Subtotal", "\$720.00"),
          const SizedBox(height: 8),
          _summaryRow("Shipping", "Free"),
          const Divider(height: 24),
          _summaryRow("Total", "\$720.00", isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text("Checkout Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? textMain : Colors.grey, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
        Text(value, style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 14)),
      ],
    );
  }
}