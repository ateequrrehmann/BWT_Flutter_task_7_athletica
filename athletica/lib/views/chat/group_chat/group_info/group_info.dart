import 'package:athletica/provider/future_provider/group_member_provider/group_member_provider.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/services/phone_service/phone_service.dart';
import 'package:athletica/views/chat/group_chat/add_member/add_member.dart';
import 'package:athletica/views/chat/group_chat/group_info/widget/member_list_tile.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/user_data/user_data.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class GroupInfo extends StatefulWidget {
  final String groupName;
  final String groupId;

  const GroupInfo({super.key, required this.groupName, required this.groupId});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List membersList = [];
  final PhoneService _phoneService = PhoneService();
  final ChatService _chatService = ChatService();
  bool isLoading = false;
  String? phone;

  fetchData() async {
    setState(() {
      isLoading=true;
    });
    phone = await _phoneService.fetchData();
    setState(() {
      isLoading=false;
    });
  }

  void showLeaveDialog(String phone, List<UserData> memberList, String text) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: ListTile(
              onTap: () {
                _chatService.onLeaveGroup(phone, memberList, widget.groupId);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CustomBottomNavigationBar()),
                    (route) => false);
              },
              title: Text(text),
            ),
          );
        });
  }

  void showRemoveDialog(
      int index, String phone, List<UserData> memberList, String text) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: ListTile(
              onTap: () => _chatService.removeUser(
                  index, phone, memberList, widget.groupId),
              title: Text(text),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Group Info'),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Consumer(builder: (context, ref, child) {
        final data = ref.watch(groupMemberProvider(widget.groupId));
        return data.when(
          data: (member) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: size.height / 0.8.h,
                    width: size.width / 0.3.w,
                    child: Row(
                      children: [
                        Container(
                          height: size.height / 1.7.h,
                          width: size.width / 1.7.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: Icon(Icons.group, size: size.width / 3.w),
                        ),
                        SizedBox(
                          width: size.width / 4.w,
                        ),
                        Expanded(
                          child: Text(
                            widget.groupName,
                            style: TextStyle(
                                fontSize: size.width / 17.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 1.5.h,
                  ),
                  SizedBox(
                    width: size.width / 0.3.w,
                    child: Text(
                      '${member.length} Members',
                      style: TextStyle(
                          fontSize: size.width / 5.5.w,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 65.h,
                  ),
                  ListTile(
                    onTap: () async {
                      if (_chatService.checkAdmin(member, phone!)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMember(
                                  groupName: widget.groupName,
                                  groupId: widget.groupId,
                                  membersList: member,
                                )));
                      } else {
                        reusableSnackBar(context,
                            'You don\'t have enough rights to remove members');
                      }
                    },
                    leading: const Icon(
                      Icons.add,
                    ),
                    title: Text(
                      'Add member',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: size.width / 5.5.w,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MemberListTile(
                            userData: member[index],
                            onTap: () async {
                              showRemoveDialog(index, phone!, member,
                                  'Remove this member');
                            },
                            size: size);
                      },
                      itemCount: member.length,
                      shrinkWrap: true,
                    ),
                  ),
                  ListTile(
                    onTap: () {

                      if (_chatService.checkAdmin(member, phone!)) {
                        reusableSnackBar(context,
                            'You will not leave the group');

                      } else {
                        showLeaveDialog(
                            phone!, member, 'Do you want to leave');
                      }
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      'Leave Group',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.width / 5.5.w,
                          color: Colors.redAccent),
                    ),
                  )

                ],
              ),
            );

          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        );
      }),

    );
  }
}
