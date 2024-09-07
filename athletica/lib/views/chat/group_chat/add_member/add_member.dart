import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/views/chat/group_chat/widget/group_member_list_tile.dart';
import 'package:athletica/views/chat/widget/chat_text_field.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../group_info/group_info.dart';

class AddMember extends StatefulWidget {
  final String groupName;
  final String groupId;
  final List<UserData> membersList;

  const AddMember(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.membersList});

  @override
  State<AddMember> createState() => _AddMembersInGroupAfterCreation();
}

class _AddMembersInGroupAfterCreation extends State<AddMember> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  List membersList = [];

  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    userMap = await _chatService.onSearch(_searchController);
    setState(() {
      isLoading = false;
    });
  }

  void onAddMembers(List<UserData> membersList) async {
    bool data = _chatService.onAddMembers(membersList,
        UserData.fromMap(userMap!), widget.groupId, widget.groupName);

    if (data) {
      reusableSnackBar(context, 'User added successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GroupInfo(
                  groupName: widget.groupName, groupId: widget.groupId)));
    } else {
      reusableSnackBar(context, 'User already exists');
    }

    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Add Members"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height / 7.h,
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Expanded(
                    child: ChatTextField(
                        searchController: _searchController,
                        icon: Icons.search,
                        onSubmitted: onSearch),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 5.h,
                    width: size.width / 5.h,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch, child: const Text('Search')),
            userMap != null
                ? GroupMemberListTile(
                    userData: UserData.fromMap(userMap!),
                    onTap: () {
                      onAddMembers(widget.membersList);
                    },
                    icon: Icons.add)
                : const SizedBox(),
          ],
        ));
  }
}
