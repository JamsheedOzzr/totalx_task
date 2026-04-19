import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'otp_screen.dart';

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
        // Success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OTPScreen()),
        );
      } else {
        // Show specific error from MSG91
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiErrorMsg)),
        );
      }
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        /// 🔹 Replace with your image
                        const Icon(Icons.phone_android, size: 120),

                        const SizedBox(height: 40),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Enter Phone Number",
                              style: TextStyle(fontSize: 18)),
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
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

                        const Text(
                          "By Continuing, I agree to Terms & Conditions",
                          style: TextStyle(fontSize: 12),
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
                                : const Text("Get OTP"),
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

