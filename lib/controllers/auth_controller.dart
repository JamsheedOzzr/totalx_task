import 'package:flutter/material.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _phoneNumber;
  String? _reqId;
  
  bool get isLoading => _isLoading;
  String? get phoneNumber => _phoneNumber;
  String? get reqId => _reqId;

  AuthController() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _phoneNumber = prefs.getString('phone_number');
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    _phoneNumber = number;
  }

  Future<String?> sendOTP(String phoneNumber) async {
    setLoading(true);
    setPhoneNumber(phoneNumber);
    
    final formattedNumber = phoneNumber.startsWith('91') ? phoneNumber : '91$phoneNumber';
    
    try {
      final data = {
        'identifier': formattedNumber
      };
      
      final response = await OTPWidget.sendOTP(data);
      
      if (response != null && (response['type'] == 'success' || response['type'] == 'success')) {
        _reqId = response['message']?.toString() ?? response['reqId']?.toString();
        setLoading(false);
        return null; 
      } else {
        final errorMessage = response != null && response['message'] != null 
          ? response['message'].toString() 
          : 'Failed to send OTP';
        setLoading(false);
        return errorMessage;
      }
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  Future<bool> verifyOTP(String otp) async {
    if (_phoneNumber == null || _reqId == null) return false;
    
    setLoading(true);

    try {
      final data = {
        'reqId': _reqId!,
        'otp': otp
      };
      final response = await OTPWidget.verifyOTP(data);
      
      if (response != null && response['type'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone_number', _phoneNumber!);
        setLoading(false);
        return true;
      } else {
        setLoading(false);
        return false;
      }
    } catch (e) {
      setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone_number');
    _phoneNumber = null;
    _reqId = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> resendOTP() async {
    if (_phoneNumber == null) return "No phone number found";
    return await sendOTP(_phoneNumber!);
  }
}
