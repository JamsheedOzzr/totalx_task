import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (user.imageUrl.isNotEmpty) {
      if (user.imageUrl.startsWith('http')) {
        imageProvider = NetworkImage(user.imageUrl);
      } else {
        imageProvider = FileImage(File(user.imageUrl));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: imageProvider,
            child: user.imageUrl.isEmpty ? const Icon(Icons.person) : null,
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              Text("Age: ${user.age}"),
            ],
          )
        ],
      ),
    );
  }
}
