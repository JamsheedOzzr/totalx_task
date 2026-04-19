import 'package:flutter/material.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _phoneNumber;
  String? _reqId;
  
  bool get isLoading => _isLoading;
  String? get phoneNumber => _phoneNumber;
  String? get reqId => _reqId;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    _phoneNumber = number;
  }

  /// Returns null if successful, or an error message string if failed
  Future<String?> sendOTP(String phoneNumber) async {
    setLoading(true);
    setPhoneNumber(phoneNumber);
    
    // Ensure phoneNumber has country code for MSG91 (91 for India)
    final formattedNumber = phoneNumber.startsWith('91') ? phoneNumber : '91$phoneNumber';
    
    try {
      final data = {
        'identifier': formattedNumber
      };
      // sendOTP from SDK skips the browser's XmlHttpRequest, bypassing CORS automatically!
      final response = await OTPWidget.sendOTP(data);
      print('Send OTP Response: $response');
      
      if (response != null && (response['type'] == 'success' || response['type'] == 'success')) {
        // Extract the request ID
        _reqId = response['message']?.toString() ?? response['reqId']?.toString();
        setLoading(false);
        return null; // Success
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

  /// Returns true if OTP verification was successful
  Future<bool> verifyOTP(String otp) async {
    if (_phoneNumber == null || _reqId == null) return false;
    
    setLoading(true);

    try {
      final data = {
        'reqId': _reqId!,
        'otp': otp
      };
      final response = await OTPWidget.verifyOTP(data);
      print('Verify OTP Response: $response');
      
      if (response != null && response['type'] == 'success') {
        // SDK properly delegates and doesn't hit Web Block
        setLoading(false);
        return true;
      } else {
        setLoading(false);
        return false;
      }
    } catch (e) {
      print('Exception in verifyOTP: $e');
      setLoading(false);
      return false;
    }
  }

  /// Clears stored authentication data
  void logout() {
    _phoneNumber = null;
    _reqId = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Resends OTP to the current phone number
  Future<String?> resendOTP() async {
    if (_phoneNumber == null) return "No phone number found";
    return await sendOTP(_phoneNumber!);
  }
}
