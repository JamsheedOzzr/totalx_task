import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Dummy login method for now
  Future<void> sendOTP(String phoneNumber) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    setLoading(false);
    // Proceed to next step
  }
}
