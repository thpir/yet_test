import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inspiration_screen.dart';
import 'creator_screen.dart';
import 'maps_screen.dart';

import '../../../controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    InspirationScreen(),
    CreatorScreen(),
    MapsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenController = Provider.of<HomeScreenController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('The best is ', style: TextStyle(fontFamily: 'Pacifico'),),
            Image.asset(
              'assets/launcher_icons/logo.png',
              width: 45,
              height: 45,
            ),
            const Text(' to come!', style: TextStyle(fontFamily: 'Pacifico'),)
          ],
        ),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(child: _widgetOptions.elementAt(screenController.selectedScreen)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), label: 'Inspiration'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined), label: 'Map'),
        ],
        currentIndex: screenController.selectedScreen,
        selectedItemColor: Colors.teal,
        onTap: screenController.switchScreen,
      ),
    );
  }
}
