import 'package:flutter/material.dart';
import 'package:wish_list/screens/signIn.dart';

import '../services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogOut() async {

    setState(() => _isLoading = true);

    try {
      await _authService.logout();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
              (route) => false,
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xff141217),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2A2635), // Dark background
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const SignInPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (_isLoading) {
                          return;
                        }
                        _handleLogOut();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:
                        _isLoading ?
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ) :
                        Text(
                          "Log Out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
