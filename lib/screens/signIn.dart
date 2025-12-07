import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/constants/app_strings.dart';
import 'package:wish_list/screens/signUp.dart';
import 'package:wish_list/utils/form_validation.dart';

import '../providers/wish_list_provider.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _userNameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameOrEmailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _userNameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {

      final userCredential = await _authService.login(
          _userNameOrEmailController.text.trim(),
          _passwordController.text
      );

      if (userCredential.user != null && mounted) {
        context.read<WishListProvider>().setUserData(userCredential.user!.uid);
        Navigator.pushReplacementNamed(context, '/home');
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
      backgroundColor: Color(0xff141217),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppStrings.signInTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      AppStrings.signInSubtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFormField(
                      controller: _userNameOrEmailController,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.usernameOrEmailHint,
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                      validator: Validators.validateUsernameOrEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFormField(
                      controller: _passwordController,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.passwordHint,
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: Validators.validatePassword
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignIn,
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(0xff4D439B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                            const Text(AppStrings.logInButton, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: TextStyle(color: Color(0xffBBB4C3), fontSize: 14),
                      children: [
                        TextSpan(
                          text: AppStrings.register,
                          style: TextStyle(
                            color: Color(0xffC9B6E3),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                  const SignUpPage(),
                                  transitionsBuilder:
                                      (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
