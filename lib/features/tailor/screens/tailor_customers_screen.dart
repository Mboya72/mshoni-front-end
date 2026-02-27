import 'dart:async';
import 'package:flutter/material.dart';

// --- THEME CONSTANTS ---
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color textMain = Color(0xFF1A1D21);

enum TailorWorkMode { jobs, shop }

class TailorCustomersScreen extends StatefulWidget {
  const TailorCustomersScreen({super.key});

  @override
  State<TailorCustomersScreen> createState() => _TailorCustomersScreenState();
}

class _TailorCustomersScreenState extends State<TailorCustomersScreen> {
  // We start at a high middle number (e.g., 501) to allow infinite swiping left or right
  late PageController _advertController;
  int _currentAdIndex = 0;
  late Timer _timer;
  TailorWorkMode _currentMode = TailorWorkMode.jobs;

  final List<Map<String, dynamic>> _ads = [
    {"title": "Wedding Season", "desc": "Custom tuxedos from KSh 25k", "icon": Icons.auto_awesome, "color": Color(0xFF4F46E5)},
    {"title": "Linen Flash Sale", "desc": "30% off all linen shirts", "icon": Icons.bolt_rounded, "color": Color(0xFF0891B2)},
    {"title": "Reward Program", "desc": "Earn KSh 1k per referral", "icon": Icons.stars_rounded, "color": Color(0xFFD97706)},
  ];

  @override
  void initState() {
    super.initState();
    // 501 is a multiple of 3, so it starts at the first ad but allows endless scrolling
    _advertController = PageController(initialPage: 501);

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_advertController.hasClients) {
        _advertController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _advertController.dispose();
    super.dispose();
  }

  // --- MODAL SHEET ---
  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            const Text("List New Product", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain)),
            const SizedBox(height: 25),
            _buildImageUploadPlaceholder(),
            const SizedBox(height: 25),
            _buildInputField("Garment Name", "e.g. Slim Fit Blazer"),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildInputField("Price (KSh)", "12,000")),
                const SizedBox(width: 15),
                Expanded(child: _buildInputField("Available Sizes", "M, L, XL")),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: skyBluePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                child: const Text("Publish to Store", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: skyScaffoldBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentMode == TailorWorkMode.shop
          ? FloatingActionButton.extended(
        onPressed: () => _showAddProductSheet(context),
        backgroundColor: skyBluePrimary,
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label: const Text("Add Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildInfiniteCarousel()),
          SliverToBoxAdapter(child: _buildModeToggle()),
          SliverToBoxAdapter(child: _buildQuickActions()),

          // List Title
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_currentMode == TailorWorkMode.jobs ? "Active Service Jobs" : "Store Catalog",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                  Text(_currentMode == TailorWorkMode.jobs ? "4 Orders" : "24 Items",
                      style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _currentMode == TailorWorkMode.jobs ? _buildJobsList() : _buildInventoryGrid(),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  // --- COMPONENT BUILDERS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Business Hub", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: textMain, letterSpacing: -0.8)),
              Text("Infinite Growth, Tailored for You", style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            children: [
              _buildTopIcon(Icons.bookmark_outline_rounded),
              const SizedBox(width: 10),
              _buildCartIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfiniteCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _advertController,
            onPageChanged: (index) => setState(() => _currentAdIndex = index % _ads.length),
            itemBuilder: (context, index) {
              final ad = _ads[index % _ads.length];
              return _buildAdCard(ad);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_ads.length, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: _currentAdIndex == index ? 18 : 6,
            decoration: BoxDecoration(color: _currentAdIndex == index ? skyBluePrimary : Colors.black12, borderRadius: BorderRadius.circular(10)),
          )),
        ),
      ],
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: [ad['color'], ad['color'].withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, bottom: -20, child: Icon(ad['icon'], color: Colors.white.withOpacity(0.15), size: 120)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ad['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              SizedBox(width: 180, child: Text(ad['desc'], style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            _toggleBtn("Service Jobs", TailorWorkMode.jobs),
            _toggleBtn("Digital Shop", TailorWorkMode.shop),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String text, TailorWorkMode mode) {
    bool active = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: active ? skyBluePrimary : Colors.transparent, borderRadius: BorderRadius.circular(18)),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.black45, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInventoryGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.8),
      delegate: SliverChildBuilderDelegate(
            (context, i) => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(width: double.infinity, decoration: BoxDecoration(color: skyBluePrimary.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))), child: const Icon(Icons.inventory_2_outlined, color: skyBluePrimary, size: 32)),
                    Positioned(top: 8, right: 8, child: CircleAvatar(radius: 14, backgroundColor: Colors.white.withOpacity(0.8), child: const Icon(Icons.bookmark_border_rounded, size: 16, color: skyBluePrimary))),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Linen Shirt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("KSh 3,500", style: TextStyle(color: skyBluePrimary, fontWeight: FontWeight.w900)),
                ]),
              ),
            ],
          ),
        ),
        childCount: 8,
      ),
    );
  }

  Widget _buildJobsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              const CircleAvatar(radius: 26, backgroundColor: skyScaffoldBg, child: Icon(Icons.person, color: skyBluePrimary)),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Bespoke Suit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("James M. • KSh 35,000", style: TextStyle(fontSize: 12, color: Colors.black45)),
                ]),
              ),
              const Icon(Icons.chevron_right, color: Colors.black12),
            ],
          ),
        ),
        childCount: 4,
      ),
    );
  }

  // --- UTILS ---
  Widget _buildTopIcon(IconData icon) {
    return Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(icon, color: textMain, size: 24));
  }

  Widget _buildCartIcon() {
    return Stack(children: [
      _buildTopIcon(Icons.shopping_bag_outlined),
      Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle), child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))
    ]);
  }

  Widget _buildQuickActions() {
    return SizedBox(height: 100, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
      _actionIcon(Icons.style_outlined, "Designs"),
      _actionIcon(Icons.inventory_outlined, "Stock"),
      _actionIcon(Icons.receipt_long_outlined, "Payouts"),
      _actionIcon(Icons.group_outlined, "Team"),
    ]));
  }

  Widget _actionIcon(IconData icon, String label) {
    return Padding(padding: const EdgeInsets.only(right: 25), child: Column(children: [
      Container(height: 56, width: 56, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(icon, color: skyBluePrimary)),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMain)),
    ]));
  }

  Widget _buildImageUploadPlaceholder() {
    return Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: skyScaffoldBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: skyBluePrimary.withOpacity(0.2), width: 2)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_upload_outlined, size: 48, color: skyBluePrimary), SizedBox(height: 12), Text("Add Garment Photos", style: TextStyle(color: skyBluePrimary, fontWeight: FontWeight.bold))]));
  }

  Widget _buildInputField(String label, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
      const SizedBox(height: 8),
      TextField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: skyScaffoldBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
    ]);
  }
}