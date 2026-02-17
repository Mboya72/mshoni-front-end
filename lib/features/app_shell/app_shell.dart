import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  final String role; // 'tailor' or 'customer'

  const AppShell({
    super.key,
    required this.role,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;
  late final List<NavigationDestination> _destinations;

  @override
  void initState() {
    super.initState();

    if (widget.role == 'tailor') {
      _screens = const [
        Center(child: Text('Tailor Home')),
        Center(child: Text('Jobs')),
        Center(child: Text('Orders')),
        Center(child: Text('Profile')),
      ];

      _destinations = const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.work_outline),
          selectedIcon: Icon(Icons.work),
          label: 'Jobs',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      // customer
      _screens = const [
        Center(child: Text('Customer Home')),
        Center(child: Text('Browse Tailors')),
        Center(child: Text('Chats')),
        Center(child: Text('Profile')),
      ];

      _destinations = const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Tailors',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
