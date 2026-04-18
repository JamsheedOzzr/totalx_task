import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 25),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Demo User"),
              Text("Age: 25"),
            ],
          )
        ],
      ),
    );
  }
}
