import 'package:flutter/material.dart';
import 'package:shot_call/home_screen.dart';
import 'package:shot_call/parties_screen.dart';

class BasicBottomNavBar extends StatefulWidget {
  const BasicBottomNavBar({super.key});

  @override
  State<BasicBottomNavBar> createState() => _BasicBottomNavBarState();
}

class _BasicBottomNavBarState extends State<BasicBottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    PartiesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Wód-call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Imprezki',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
