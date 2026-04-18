import 'package:flutter/material.dart';
import 'add_user_screen.dart';
import '../widgets/user_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: const Text(
                "Nilambur",
                style: TextStyle(color: Colors.white),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "search by name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.filter_list)
                ],
              ),
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text("Users Lists"),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, index) => const UserCard(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
