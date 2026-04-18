import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text("Add A New User",
                style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {},
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Save"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
