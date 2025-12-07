import 'package:firebase_auth/firebase_auth.dart';
import 'package:wish_list/constants/app_strings.dart';
import 'analytics_service.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();
  final AnalyticsService _analytics = AnalyticsService();

  Future<UserCredential> register(String username, String email, String password) async {
    try {

      final existingEmail = await _dbService.getUsernameToEmail(username);

      if (existingEmail != null) {
        throw FirebaseAuthException(
            code: 'username-already-in-use',
            message: 'This username is already taken.'
        );
      }

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _dbService.createUserDocument(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
      );

      await _analytics.logSignUpSuccess();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      await _analytics.logSignUpError(e.code);
      throw _handleError(e);
    }
  }

  Future<UserCredential> login(String emailOrUsername, String password) async {
    try {

      String email;
      String loginMethod;
      if (_isEmail(emailOrUsername)) {
        loginMethod = "Email";
        email = emailOrUsername;
      }else {
        loginMethod = "Username";
        String? foundEmail = await _dbService.getUsernameToEmail(emailOrUsername);
        if (foundEmail == null) {
          throw AppStrings.usernameNotFound;
        }
        email = foundEmail;
      }

      await _analytics.logLoginSuccess(loginMethod);

      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      await _analytics.logLoginError(e.code);
      throw _handleError(e);
    }
  }


  Future<void> logout() async {
    await _analytics.logLogout();
    await _auth.signOut();
  }

  bool _isEmail(String input) {
    return input.contains('@');
  }

  User? get currentUser => _auth.currentUser;
  String? get currentUsername => _auth.currentUser?.displayName;

  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AppStrings.emailAlreadyInUse;
      case 'username-already-in-use':
        return "Username is already taken, please choose another one.";
      case 'invalid-credential':
        return AppStrings.invalidCredential;
      default:
        return '${AppStrings.errorPrefix}${e.message}';
    }
  }
}
