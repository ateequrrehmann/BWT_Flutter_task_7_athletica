import 'package:athletica_admin/models/user_data/user_data.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserData user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: ${user.number}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Bio: ${user.bio}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('User ID: ${user.userId}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
