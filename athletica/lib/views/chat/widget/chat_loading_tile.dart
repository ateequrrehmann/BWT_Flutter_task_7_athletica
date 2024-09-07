import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class ChatLoadingTile extends StatefulWidget {
  const ChatLoadingTile({super.key});

  @override
  State<ChatLoadingTile> createState() => _ChatLoadingTile();
}

class _ChatLoadingTile extends State<ChatLoadingTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.06),
      ),
      title: Container(
        width: size.width/0.4,
        height: size.width * 0.05,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(2.w))),
      ),
      subtitle: Container(
        width: size.width/0.5,
        height: size.width * 0.05,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(2.w))),
      ),
      trailing: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.06),
      ),
    );
  }
}
