import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mshoni_frontend/features/customer/screens/customer_home_screen.dart';
import 'package:mshoni_frontend/features/customer/screens/customer_message_screen.dart';
import 'package:mshoni_frontend/features/customer/screens/customer_tailors_screen.dart';
import 'package:mshoni_frontend/features/customer/screens/customer_projects_screen.dart'; // new
import 'package:mshoni_frontend/features/customer/screens/customer_profile_screen.dart';
import 'package:mshoni_frontend/features/tailor/screens/tailor_home_screen.dart';
import 'package:mshoni_frontend/features/tailor/screens/tailor_message_screen.dart';
import 'package:mshoni_frontend/features/tailor/screens/tailor_customers_screen.dart';
import 'package:mshoni_frontend/features/tailor/screens/tailor_projects_screen.dart';
import 'package:mshoni_frontend/features/tailor/screens/tailor_profile_screen.dart';
import '../../core/theme/app_colors.dart';

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
  late List<Widget> _navItems;
  late String _title;

  @override
  void initState() {
    super.initState();

    if (widget.role == UserRole.customer) {
      _title = 'Customer Home';

      _pages = [
        const CustomerHomeScreen(),
        const CustomerMessageScreen(),
        const CustomerTailorsScreen(),
        const CustomerProjectsScreen(), // new
        const CustomerProfileScreen(),
      ];

      _navItems = const [
        Icon(Icons.dashboard, size: 28, color: Colors.white),
        Icon(Icons.message, size: 28, color: Colors.white),
        Icon(Icons.people, size: 28, color: Colors.white),
        Icon(Icons.work, size: 28, color: Colors.white), // projects icon
        Icon(Icons.person, size: 28, color: Colors.white),
      ];
    } else {
      _title = 'Tailor Home';

      _pages = [
        const TailorHomeScreen(),
        const TailorMessageScreen(),
        const TailorCustomersScreen(),
        const TailorProjectsScreen(),
        const TailorProfileScreen(),
      ];

      _navItems = const [
        Icon(Icons.dashboard, size: 28, color: Colors.white),
        Icon(Icons.message, size: 28, color: Colors.white),
        Icon(Icons.people, size: 28, color: Colors.white),
        Icon(Icons.work, size: 28, color: Colors.white),
        Icon(Icons.person, size: 28, color: Colors.white),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
        key: _navKey,
        index: _currentIndex,
        height: 60,
        backgroundColor: AppColors.backgroundColor,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.easeOutCubic,
        items: _navItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
