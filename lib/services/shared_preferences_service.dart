import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _buyModeKeyPrefix = 'buy_mode_';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveBuyMode(bool isBuyMode) async {
    try {
      await _prefs.setBool(_buyModeKeyPrefix, isBuyMode);
      print('Buy mode saved in $isBuyMode mode');
    } catch (e) {
      print('Error saving buy mode: $e');
      throw Exception('Failed to save buy mode');
    }
  }

  bool getBuyMode() {
    try {
      return _prefs.getBool(_buyModeKeyPrefix) ?? true;
    } catch (e) {
      print('Error getting buy mode: $e');
      return true;
    }
  }

  Future<void> removeBuyMode() async {
    try {
      await _prefs.remove(_buyModeKeyPrefix);
      print('Buy mode was removed');
    } catch (e) {
      print('Error removing buy mode: $e');
      throw Exception('Failed to remove buy mode');
    }
  }

}
