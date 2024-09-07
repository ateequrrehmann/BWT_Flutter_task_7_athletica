import 'package:athletica/models/user_data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../color/colors.dart';


class ChatListTile extends StatefulWidget {
  final String roomId;
  final UserData user;
  final VoidCallback onTap;
  const ChatListTile({super.key, required this.roomId, required this.user, required this.onTap});

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:widget.onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.imageUrl!),
      ),
      title: Text(
        widget.user.name,
        style: TextStyle(
            color: chatHomePageTextColor,
            fontSize: 17.5.sp,
            fontWeight: FontWeight.w500),
      ),
      subtitle: Text(widget.user.bio!),
      trailing: const Icon(
        Icons.chat,
        color: chatHomePageIconColor,
      ),
    );
  }
}
