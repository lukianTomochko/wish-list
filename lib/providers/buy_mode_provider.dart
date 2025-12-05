import 'package:flutter/material.dart';
import 'package:wish_list/services/shared_preferences_service.dart';

class BuyModeProvider extends ChangeNotifier {
  final SharedPreferencesService _prefsService;

  bool _isBuyMode = true;

  BuyModeProvider({required SharedPreferencesService prefsService})
      : _prefsService = prefsService {
    _loadBuyMode();
  }

  bool get isBuyMode => _isBuyMode;

  Future<void> _loadBuyMode() async {
    _isBuyMode = _prefsService.getBuyMode();
    notifyListeners();
  }

  Future<void> setBuyMode(bool isBuyMode) async {
    _isBuyMode = isBuyMode;
    await _prefsService.saveBuyMode(isBuyMode);
    notifyListeners();
  }

  Future<void> toggleBuyMode() async {
    await setBuyMode(!_isBuyMode);
  }
}
