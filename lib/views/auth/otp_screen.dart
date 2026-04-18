import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => Container(
                  width: 45,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("0"),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("59 Sec", style: TextStyle(color: Colors.red)),

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
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
