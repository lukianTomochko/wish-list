import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logLoginSuccess(String method) async {
    await _analytics.logEvent(
      name: 'login_success',
      parameters: {
        'method': method,
        'timestamp': DateTime.now().toString(),
      },
    );
  }

  Future<void> logSignUpSuccess() async {
    await _analytics.logEvent(
      name: 'sign_up_success',
      parameters: {
        'timestamp': DateTime.now().toString(),
      },
    );
  }

  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  Future<void> logLoginError(String errorCode) async {
    await _analytics.logEvent(
      name: 'login_error',
      parameters: {'error_code': errorCode},
    );
  }

  Future<void> logSignUpError(String errorCode) async {
    await _analytics.logEvent(
      name: 'sign_up_error',
      parameters: {'error_code': errorCode},
    );
  }

}
