import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/screens/signIn.dart';
import 'package:wish_list/constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/form_validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
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
                      AppStrings.signUpTitle,
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
                      AppStrings.signUpSubtitle,
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
                      controller: _usernameController ,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.usernameHint,
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                      validator: Validators.validateUsername,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFormField(
                      controller: _emailController ,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.emailHint,
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                      validator: Validators.validateEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFormField(
                      controller: _passwordController ,
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
                      validator: Validators.validatePassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.confirmPasswordHint,
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                      obscureText: _obscureText,
                      validator: (value) => Validators.validatePasswordMatch(
                        _passwordController.text,
                        value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
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
                        Text(
                          AppStrings.registerButton,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.alreadyHaveAccount,
                        style: TextStyle(color: Color(0xffBBB4C3), fontSize: 14),
                        children: [
                          TextSpan(
                            text: AppStrings.logIn,
                            style: TextStyle(
                              color: Color(0xffC9B6E3),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const SignInPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
