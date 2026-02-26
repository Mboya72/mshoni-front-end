import 'dart:async';
import 'package:flutter/material.dart';

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

  // Branding Palette
  static const Color accentBlue = Color(0xFF4B84F1);
  static const Color scaffoldBg = Color(0xFFF8F9FA);
  static const Color textMain = Color(0xFF1A1D21);

  final List<Map<String, String>> banners = [
    {'title': 'Exclusive Offers', 'sub': '20% OFF Custom Suits', 'date': 'Valid until Oct 2026', 'image': 'https://images.unsplash.com/photo-1594932224828-b4b05a832fe3?w=800'},
    {'title': 'Premium Fabrics', 'sub': 'New Silk Arrival', 'date': 'Limited Edition', 'image': 'https://images.unsplash.com/photo-1598454444427-8b94988c202a?w=800'},
  ];

  final List<Map<String, dynamic>> tailorCategories = [
    {'name': 'Suits', 'icon': Icons.accessibility_new},
    {'name': 'Traditional', 'icon': Icons.checkroom},
    {'name': 'Wedding', 'icon': Icons.favorite_border},
    {'name': 'Luxury', 'icon': Icons.diamond_outlined},
  ];

  final List<Map<String, dynamic>> clothCategories = [
    {'name': 'Shirts', 'icon': Icons.layers_outlined},
    {'name': 'Dresses', 'icon': Icons.woman_outlined},
    {'name': 'Outerwear', 'icon': Icons.wb_sunny_outlined},
    {'name': 'Fabrics', 'icon': Icons.texture_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_bannerController.hasClients) {
        _currentBannerIndex = (_currentBannerIndex + 1) % banners.length;
        _bannerController.animateToPage(_currentBannerIndex,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
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
        slivers: [
          // 1. Updated Brand Header (No Profile/Photo)
          SliverToBoxAdapter(child: _buildBrandHeader()),

          // 2. Search & Filter Bar
          SliverToBoxAdapter(child: _buildSearchBar()),

          // 3. Centered Banner Box
          SliverToBoxAdapter(child: _buildBannerSlider()),

          // 4. Mode Toggle (Hire vs Buy)
          SliverToBoxAdapter(child: _buildModeToggle()),

          // 5. Dynamic Categories
          SliverToBoxAdapter(child: _buildCategoryList()),

          // 6. View More Button
          SliverToBoxAdapter(child: _buildViewMoreButton()),

          // 7. Section Titles
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_currentMode == ViewMode.hire ? "Top Rated Tailors" : "Featured Products",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                  const Text("View all", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ),

          // 8. Content Grid or List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _currentMode == ViewMode.hire ? _buildTailorList() : _buildProductGrid(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // --- UI SECTIONS ---

  Widget _buildBrandHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tailor Marketplace",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: textMain, letterSpacing: -0.5)),
              Text("Find expert services & quality apparel",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          Row(
            children: [
              _topIconButton(Icons.shopping_cart_outlined),
              const SizedBox(width: 8),
              _topIconButton(Icons.favorite_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: Icon(icon, size: 22, color: textMain),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade100)
        ),
        child: const Row(
          children: [
            SizedBox(width: 15),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search tailors, styles or clothes...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey)
                    )
                )
            ),
            Icon(Icons.tune, color: accentBlue),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade100)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(banners[index]['title']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(banners[index]['sub']!,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBlue,
                                    shape: const StadiumBorder(),
                                    elevation: 0
                                ),
                                child: const Text("Explore", style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                              child: Image.network(banners[index]['image']!, fit: BoxFit.cover, height: double.infinity)
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6, width: _currentBannerIndex == i ? 18 : 6,
                decoration: BoxDecoration(color: _currentBannerIndex == i ? accentBlue : Colors.grey.shade300, borderRadius: BorderRadius.circular(3))
            ))
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade100)
        ),
        child: Row(
          children: [
            _toggleBtn("Find Tailor", ViewMode.hire),
            _toggleBtn("Shop Clothes", ViewMode.buy),
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
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: active ? accentBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(12)
          ),
          alignment: Alignment.center,
          child: Text(text,
              style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = _currentMode == ViewMode.hire ? tailorCategories : clothCategories;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade100)
                ),
                child: Icon(categories[i]['icon'], color: accentBlue, size: 24),
              ),
              const SizedBox(height: 8),
              Text(categories[i]['name'], style: const TextStyle(fontSize: 12, color: textMain)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade100)
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_rounded, size: 18, color: accentBlue),
            SizedBox(width: 8),
            Text("View All Categories",
                style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8
      ),
      delegate: SliverChildBuilderDelegate(
            (context, i) => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(color: Colors.grey.shade50, width: double.infinity, child: const Icon(Icons.image, color: Colors.grey, size: 40))
                  )
              ),
              const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Premium Shirt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text("\$45.00", style: TextStyle(color: accentBlue, fontWeight: FontWeight.w600)),
                    ],
                  )
              ),
            ],
          ),
        ),
        childCount: 4,
      ),
    );
  }

  Widget _buildTailorList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100)
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: scaffoldBg, child: Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 15),
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Master Artisan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("15 years experience", style: TextStyle(fontSize: 12, color: Colors.grey))
                  ]
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
        childCount: 4,
      ),
    );
  }
}