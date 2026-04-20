import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/auth_controller.dart';
import '../home/home_screen.dart';
import '../../utils/app_images.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _resendOTP() async {
    if (_secondsRemaining > 30) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Please Wait"),
          content: const Text("You can only resend the OTP after 30 seconds have passed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final authController = context.read<AuthController>();
    final error = await authController.resendOTP();
    
    if (!mounted) return;
    
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Resent successfully!')),
      );
      _startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend: $error')),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP.')),
      );
      return;
    }

    final authController = context.read<AuthController>();
    final success = await authController.verifyOTP(otp);

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP or Verification Failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(AppImages.otpIllustration, height: 120),
                      const SizedBox(height: 20),
                      const Text("OTP Verification",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Consumer<AuthController>(
                        builder: (context, authController, _) {
                          final phone = authController.phoneNumber ?? '';
                          final maskedPhone = phone.length >= 2 
                              ? "+91 *******${phone.substring(phone.length - 2)}" 
                              : phone;
                          return Text(
                            "Enter the verification code we just sent to your number $maskedPhone",
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                        length: 6,
                        controller: _otpController,
                        defaultPinTheme: PinTheme(
                          width: 45,
                          height: 55,
                          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "$_secondsRemaining Sec",
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't receive OTP? ",
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Resend",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = _resendOTP,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      Consumer<AuthController>(
                        builder: (context, authController, _) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: authController.isLoading ? null : _verify,
                            child: authController.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Verify", style: TextStyle(fontSize: 16)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
