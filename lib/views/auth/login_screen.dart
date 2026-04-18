import 'package:flutter/material.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),

            /// 🔹 Replace with your image
            const Icon(Icons.phone_android, size: 120),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter Phone Number",
                  style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 10),

            TextField(
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OTPScreen()),
                );
              },
              child: const Text("Get OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
