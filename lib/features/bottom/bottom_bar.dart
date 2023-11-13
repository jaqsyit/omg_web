import 'package:flutter/material.dart';
import 'package:omg/features/groups/groups_screen.dart';
import 'package:omg/features/profile/profile_screen.dart';
import 'package:omg/features/workers/workers_screen.dart';

class MainBar extends StatefulWidget {
  const MainBar({super.key});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _selectedIndex = 0;

  final tabs = [
    const Placeholder(),
    const WorkersScreen(),
    const GroupsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Статистика'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.groups),
                label: Text('Жұмысшылар'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_books_outlined),
                label: Text('Емтихандар'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Профиль'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: tabs[_selectedIndex],
          )
        ],
      ),
    );
  }
}
