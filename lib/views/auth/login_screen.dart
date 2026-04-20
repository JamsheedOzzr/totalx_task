import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'otp_screen.dart';
import '../../utils/app_images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      final phone = _phoneController.text.trim();
      final apiErrorMsg = await authController.sendOTP(phone);
      if (!mounted) return;
      if (apiErrorMsg == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OTPScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiErrorMsg)),
        );
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terms & Conditions"),
        content: const SingleChildScrollView(
          child: Text(
            "Welcome to TotalX. By using this application, you agree to comply with our usage policies. "
            "We prioritize your data security and privacy in all our attendance and user management services. "
            "TotalX reserves the right to update these terms to reflect service improvements.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(AppImages.loginIllustration, height: 120),
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Enter Phone Number",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a phone number";
                            }
                            if (value.length < 10) {
                              return "Enter a valid 10-digit number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By Continuing, I agree to TotalX’s ",
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Terms and condition",
                                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
                                ),
                                const TextSpan(text: " & "),
                                TextSpan(
                                  text: "privacy policy",
                                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
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
                              onPressed: authController.isLoading ? null : _submit,
                              child: authController.isLoading 
                                ? const CircularProgressIndicator(color: Colors.white) 
                                : const Text("Get OTP", style: TextStyle(fontSize: 16)),
                            );
                          }
                        ),
                      ],
                    ),
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
