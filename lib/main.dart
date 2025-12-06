import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/providers/buy_mode_provider.dart';
import 'package:wish_list/providers/wish_list_provider.dart';
import 'package:wish_list/repositories/firestore_wishlist_repository.dart';
import 'package:wish_list/screens/homePage.dart';
import 'package:wish_list/screens/signIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wish_list/screens/signUp.dart';
import 'package:wish_list/services/auth_service.dart';
import 'package:wish_list/services/shared_preferences_service.dart';
import 'firebase_options.dart';

final sharedPreferencesService = SharedPreferencesService();

void main() async{

  // Firebase Handling
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics Error Handling
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Local storage initialization
  try {
    await sharedPreferencesService.init();
    print('SharedPreferences initialized successfully');
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }


  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BuyModeProvider(
            prefsService: sharedPreferencesService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WishListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthChecker(),
        routes: {
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<WishListProvider>();
        provider.repository = FirestoreWishListRepository(user.uid);
        provider.userId = user.uid;
        provider.loadWishLists();
      });

      return const HomePage();
    } else {
      return const SignInPage();
    }
  }
}
