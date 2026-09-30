// lib/features/auth/services/auth_service.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService extends ChangeNotifier {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyPinHash = 'pin_hash';
  static const String _keyDarkMode = 'dark_mode';

  bool _isOnboardingCompleted = false;
  bool _hasPinSet = false;
  bool _isDarkMode = false;
  bool _isAuthenticated = false;
  String? _cachedPinHash;

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get hasPinSet => _hasPinSet;
  bool get isDarkMode => _isDarkMode;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingCompleted = prefs.getBool(_keyOnboardingCompleted) ?? false;
    _cachedPinHash = prefs.getString(_keyPinHash);
    _hasPinSet = _cachedPinHash != null && _cachedPinHash!.isNotEmpty;
    _isDarkMode = prefs.getBool(_keyDarkMode) ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
    _isOnboardingCompleted = true;
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes).toString();
    await prefs.setString(_keyPinHash, hash);
    _cachedPinHash = hash;
    _hasPinSet = true;
    _isAuthenticated = true;
    notifyListeners();
  }

  bool verifyPin(String pin) {
    if (_cachedPinHash == null) return false;
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes).toString();
    return hash == _cachedPinHash;
  }

  Future<void> removePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPinHash);
    _cachedPinHash = null;
    _hasPinSet = false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
    _isDarkMode = value;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isOnboardingCompleted = false;
    _hasPinSet = false;
    _cachedPinHash = null;
    _isDarkMode = false;
    _isAuthenticated = false;
    notifyListeners();
  }
}
