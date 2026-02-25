import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mshoni/features/customer/screens/customer_home_screen.dart';
import 'package:mshoni/features/customer/screens/customer_message_screen.dart';
import 'package:mshoni/features/customer/screens/customer_tailors_screen.dart';
import 'package:mshoni/features/customer/screens/customer_projects_screen.dart';
import 'package:mshoni/features/customer/screens/customer_profile_screen.dart';
import 'package:mshoni/features/tailor/screens/tailor_home_screen.dart';
import 'package:mshoni/features/tailor/screens/tailor_message_screen.dart';
import 'package:mshoni/features/tailor/screens/tailor_customers_screen.dart';
import 'package:mshoni/features/tailor/screens/tailor_projects_screen.dart';
import 'package:mshoni/features/tailor/screens/tailor_profile_screen.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum UserRole { customer, tailor }

class DynamicNavBar extends StatefulWidget {
  final UserRole role;

  const DynamicNavBar({
    super.key,
    required this.role,
  });

  @override
  State<DynamicNavBar> createState() => _DynamicNavBarState();
}

class _DynamicNavBarState extends State<DynamicNavBar> {
  int _currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    if (widget.role == UserRole.customer) {
      _pages = const [
        CustomerHomeScreen(),
        CustomerMessageScreen(),
        CustomerTailorsScreen(),
        CustomerProjectsScreen(),
        CustomerProfileScreen(),
      ];
    } else {
      _pages = const [
        TailorHomeScreen(),
        TailorMessageScreen(),
        TailorCustomersScreen(),
        TailorProjectsScreen(),
        TailorProfileScreen(),
      ];
    }
  }

  // ✅ Outline icons with active state
  List<Widget> _buildNavItems() {
    Widget buildSvgIcon(String assetPath, int index) {
      return AnimatedScale(
        scale: _currentIndex == index ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          height: 30,
          width: 30,
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                _currentIndex == index
                    ? AppColors.primaryColor
                    : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    }

    return [
      buildSvgIcon('assets/icons/home.svg', 0),
      buildSvgIcon('assets/icons/message.svg', 1),
      buildSvgIcon('assets/icons/listings.svg', 2),
      buildSvgIcon('assets/icons/projects.svg', 3),
      buildSvgIcon('assets/icons/profile.svg', 4),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBody: true, // ✅ allows transparent curved effect

      body: _pages[_currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
        key: _navKey,
        index: _currentIndex,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.white, // ✅ navbar background
        buttonBackgroundColor: Colors.white, // ✅ center circle white
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.easeOutCubic,
        items: _buildNavItems(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
