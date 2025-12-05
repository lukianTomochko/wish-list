import '../constants/app_strings.dart';

class Validators {

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return AppStrings.emailEmpty;
    }

    if (!_emailRegExp.hasMatch(email)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? validateUsernameOrEmail(String? usernameOrEmail) {
    if (usernameOrEmail == null || usernameOrEmail.isEmpty) {
      return AppStrings.usernameOrEmailEmpty;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.passwordEmpty;
    }
    if (password.length < 4) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');

  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return AppStrings.usernameEmpty;
    }
    if (username.length < 3) {
      return AppStrings.usernameTooShort;
    }
    if (username.length > 20) {
      return AppStrings.usernameTooLong;
    }

    if (!_usernameRegExp.hasMatch(username)) {
      return AppStrings.usernameContainsAt;
    }

    return null;
  }

  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.confirmPasswordEmpty;
    }
    if (password != confirmPassword) {
      return AppStrings.passwordNoMatch;
    }
    return null;
  }
}
