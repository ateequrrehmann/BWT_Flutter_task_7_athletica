import 'package:athletica/models/user_data/user_data.dart';
import 'package:flutter/material.dart';

class GroupMemberListTile extends StatelessWidget {
  final UserData userData;
  final VoidCallback onTap;
  final IconData icon;
  const GroupMemberListTile({super.key, required this.userData, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
        NetworkImage(userData.imageUrl!),
        child: const SizedBox(
          width: 20,
          height: 20,
        ),
      ),
      title: Text(
        userData.name,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w500),
      ),
      subtitle: Text(userData.bio!),
      trailing: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
