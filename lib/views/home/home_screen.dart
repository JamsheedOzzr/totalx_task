import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_user_screen.dart';
import '../widgets/user_card.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/auth_controller.dart';
import '../auth/login_screen.dart';

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

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sort", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              Consumer<UserController>(
                builder: (context, controller, child) {
                  return Column(
                    children: [
                      RadioListTile<SortOption>(
                        title: const Text("Age - Elder"),
                        value: SortOption.elder,
                        groupValue: controller.sortOption,
                        onChanged: (val) {
                          controller.setSortOption(val!);
                          Navigator.pop(ctx);
                        },
                      ),
                      RadioListTile<SortOption>(
                        title: const Text("Age - Younger"),
                        value: SortOption.younger,
                        groupValue: controller.sortOption,
                        onChanged: (val) {
                          controller.setSortOption(val!);
                          Navigator.pop(ctx);
                        },
                      ),
                      RadioListTile<SortOption>(
                        title: const Text("Name A-Z"),
                        value: SortOption.nameAZ,
                        groupValue: controller.sortOption,
                        onChanged: (val) {
                          controller.setSortOption(val!);
                          Navigator.pop(ctx);
                        },
                      ),
                      RadioListTile<SortOption>(
                        title: const Text("Name Z-A"),
                        value: SortOption.nameZA,
                        groupValue: controller.sortOption,
                        onChanged: (val) {
                          controller.setSortOption(val!);
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        "Nilambur",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AuthController>().logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
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
                        hintText: "Search by Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showSortBottomSheet(context),
                    icon: const Icon(Icons.filter_list),
                  ),
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
