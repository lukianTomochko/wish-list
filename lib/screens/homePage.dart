import 'package:flutter/material.dart';
import 'package:wish_list/screens/settings.dart';
import 'package:wish_list/screens/sharePage.dart';
import 'package:wish_list/screens/wishListsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPageIndex = 1;
  void _navigateBottomBar(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List _pages = [
    SharePage(),
    WishListPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    "Share",
    "WishList",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff141217), // Dark purple background
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titles[_selectedPageIndex],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _pages[_selectedPageIndex],
      backgroundColor: const Color(0xff141217),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF1A1625),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFF6B6B7B),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          currentIndex: _selectedPageIndex,
          onTap: _navigateBottomBar,
          items: [

            // Share
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: "Share",
            ),

            // Home
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
            ),

            // Settings
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )


          ],
      ),
    );
  }
}
