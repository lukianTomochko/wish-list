import 'dart:async'; // Для StreamSubscription
import 'package:app_links/app_links.dart'; // Пакет для посилань
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Провайдер
import 'package:wish_list/providers/wish_list_provider.dart'; // Твій провайдер
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

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('Deep Link отримано: $uri');

      if (uri.scheme == 'wishlistapp' && uri.queryParameters.containsKey('id')) {
        final String listId = uri.queryParameters['id']!;

        Future.delayed(Duration.zero, () {
          if (mounted) _showImportDialog(listId);
        });
      }
    });
  }

  void _showImportDialog(String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF302938),
        title: Text(
          'New Wishlist Found!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Do you want to import this wishlist to your collection?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                await context.read<WishListProvider>().cloneWishList(listId);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Wishlist imported successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  _navigateBottomBar(1);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error importing list: $e')),
                  );
                }
              }
            },
            child: Text('Import', style: TextStyle(color: Color(0xffC9B6E3))),
          ),
        ],
      ),
    );
  }

  void _navigateBottomBar(int index) {
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
        backgroundColor: Color(0xff141217),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: "Share",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          )
        ],
      ),
    );
  }
}