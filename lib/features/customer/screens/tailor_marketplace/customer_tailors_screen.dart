import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tailor_profile_screen.dart';
import 'product_detail_screen.dart';
import 'customer_cart_screen.dart';
import 'customer_liked_screen.dart';

enum ViewMode { hire, buy }

class CustomerTailorsScreen extends StatefulWidget {
  const CustomerTailorsScreen({super.key});

  @override
  State<CustomerTailorsScreen> createState() => _CustomerTailorsScreenState();
}

class _CustomerTailorsScreenState extends State<CustomerTailorsScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  late Timer _timer;
  ViewMode _currentMode = ViewMode.hire;

  // --- STYLE CONSTANTS ---
  static const Color accentBlue = Color(0xFF0EA5E9); // Matching your skyBluePrimary
  static const Color scaffoldBg = Color(0xFFF0F7FF);
  static const Color textMain = Color(0xFF1A1D21);

  final List<Map<String, String>> banners = [
    {
      'title': 'Exclusive Offers',
      'sub': '20% OFF Custom Suits',
      'image': 'https://images.unsplash.com/photo-1594932224828-b4b05a832fe3?w=800'
    },
    {
      'title': 'Premium Fabrics',
      'sub': 'New Silk Arrival',
      'image': 'https://images.unsplash.com/photo-159845444427-8b94988c202a?w=800'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_bannerController.hasClients) {
        _currentBannerIndex = (_currentBannerIndex + 1) % banners.length;
        _bannerController.animateToPage(
            _currentBannerIndex,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. App Header
          SliverToBoxAdapter(child: _buildBrandHeader(context)),

          // 2. Search & Filter
          SliverToBoxAdapter(child: _buildSearchBar()),

          // 3. Promotional Slider
          SliverToBoxAdapter(child: _buildBannerSlider()),

          // 4. Mode Switcher (Hire Tailor vs Buy Clothes)
          SliverToBoxAdapter(child: _buildModeToggle()),

          // 5. Horizontal Categories
          SliverToBoxAdapter(child: _buildCategoryList()),

          // 6. Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      _currentMode == ViewMode.hire ? "Top Rated Tailors" : "Featured Apparel",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)
                  ),
                  const Text("View all", style: TextStyle(color: accentBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // 7. Main Content (List or Grid)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _currentMode == ViewMode.hire ? _buildTailorList() : _buildProductGrid(),
          ),

          // Bottom spacing for NavBar
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  // --- HEADER WIDGETS ---

  Widget _buildBrandHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mshoni Hub",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: textMain, letterSpacing: -1)),
              Text("Expert craftsmanship at your fingertips",
                  style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              _topIconButton(Icons.favorite_outline, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerLikedScreen()))),
              const SizedBox(width: 10),
              _topIconButton(Icons.shopping_bag_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerCartScreen()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
              ),
              child: const TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black26),
                    hintText: "Search designs or tailors...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18)
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              height: 55, width: 55,
              decoration: BoxDecoration(color: accentBlue, borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.tune_rounded, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // --- NAVIGATION & CATEGORIES ---

  Widget _buildModeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            _toggleBtn("Hire a Tailor", ViewMode.hire),
            _toggleBtn("Shop Products", ViewMode.buy),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String text, ViewMode mode) {
    bool active = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              color: active ? accentBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(15)
          ),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.black38, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- CONTENT ---

  Widget _buildTailorList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TailorProfileScreen())),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network('https://i.pravatar.cc/150?u=$i', width: 70, height: 70, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Savile Row Masters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Bespoke Suits • 5.0 ★", style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black12),
              ],
            ),
          ),
        ),
        childCount: 6,
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.75
      ),
      delegate: SliverChildBuilderDelegate(
            (context, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductDetailScreen())),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    child: Image.network('https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400', fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Slim Fit Blazer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("KSh 4,500", style: TextStyle(color: accentBlue, fontWeight: FontWeight.w900)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        childCount: 6,
      ),
    );
  }

  // --- HELPERS ---

  Widget _topIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: textMain),
      ),
    );
  }

  // (Filter sheet and Banner Slider logic remain mostly same but integrated into this cleaner UI)
  // Add your _showFilterSheet and _buildBannerSlider here...

  Widget _buildCategoryList() {
    // Icons for Tailors or Clothes based on mode
    final List<Map<String, dynamic>> categories = _currentMode == ViewMode.hire
        ? [{'n': 'Suits', 'i': Icons.accessibility}, {'n': 'Wedding', 'i': Icons.favorite}, {'n': 'Repair', 'i': Icons.build}, {'n': 'Uniforms', 'i': Icons.group}]
        : [{'n': 'Shirts', 'i': Icons.layers}, {'n': 'Dresses', 'i': Icons.woman}, {'n': 'Fabrics', 'i': Icons.texture}, {'n': 'Accessories', 'i': Icons.watch}];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black.withOpacity(0.05))),
                child: Icon(categories[i]['i'], color: accentBlue, size: 24),
              ),
              const SizedBox(height: 8),
              Text(categories[i]['n'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    // Your existing sheet logic...
  }

  Widget _buildBannerSlider() {
    // Your existing slider logic...
    return const SizedBox(); // Placeholder for brevity
  }
}