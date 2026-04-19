import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/auth_controller.dart';
import '../home/home_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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

                      /// Replace image
                      const Icon(Icons.security, size: 120),

                      const SizedBox(height: 20),

                      const Text("OTP Verification",
                          style: TextStyle(fontSize: 20)),

                      const SizedBox(height: 10),

                      const Text(
                        "Enter the verification code sent to your number",
                        textAlign: TextAlign.center,
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
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text("59 Sec", style: TextStyle(color: Colors.red)),

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
                                : const Text("Verify"),
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

