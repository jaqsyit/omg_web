import 'package:flutter/material.dart';
import 'package:omg/features/groups/groups_screen.dart';
import 'package:omg/features/profile/profile_screen.dart';

class MainBar extends StatefulWidget {
  const MainBar({super.key});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _selectedIndex = 0;

  final tabs = [
    Placeholder(),
    Placeholder(),
    const GroupsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.app_registration_rounded),
            label: 'Жұмысшылар',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Емтихандар',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          )
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: tabs[_selectedIndex],
    );
  }
}
