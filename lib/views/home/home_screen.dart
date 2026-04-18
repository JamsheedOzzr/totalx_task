import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_user_screen.dart';
import '../widgets/user_card.dart';
import '../../controllers/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchUsers();
    });
  }

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
                      onChanged: (val) {
                        context.read<UserController>().setSearchQuery(val);
                      },
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
              child: Consumer<UserController>(
                builder: (context, controller, child) {
                  if (controller.isLoading && controller.users.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.users.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }
                  return ListView.builder(
                    itemCount: controller.users.length,
                    itemBuilder: (_, index) {
                      return UserCard(user: controller.users[index]);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
