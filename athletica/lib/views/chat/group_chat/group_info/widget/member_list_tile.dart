import 'package:athletica/models/user_data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MemberListTile extends StatelessWidget {
  final UserData userData;
  final VoidCallback onTap;
  final Size size;
  const MemberListTile({super.key, required this.userData, required this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        onTap;
      },
      leading: CircleAvatar(
        backgroundImage:
        NetworkImage(userData.imageUrl!),
      ),
      title: Text(
        userData.name,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: size.width / 5.5.w),
      ),
      subtitle: Text(userData.bio!),
      trailing: Text(
          userData.isAdmin! ? 'Admin' : ''),
    );
  }
}
