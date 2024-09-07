import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/services/phone_service/phone_service.dart';
import 'package:athletica/views/chat/group_chat/widget/group_member_list_tile.dart';
import 'package:athletica/views/chat/widget/chat_text_field.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../create_group_screen/create_group_screen.dart';

class AddMemberInGroup extends StatefulWidget {
  const AddMemberInGroup({super.key});

  @override
  State<AddMemberInGroup> createState() => _AddMemberInGroupState();
}

class _AddMemberInGroupState extends State<AddMemberInGroup> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final PhoneService _phoneService = PhoneService();
  bool isLoading = false;
  List<UserData> membersList = [];
  Map<String, dynamic>? userMap;
  String? phone;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    userMap = await _chatService.onSearch(_searchController);
    setState(() {
      isLoading = false;
    });
    if (userMap == null) {
      reusableSnackBar(context, 'User not found');
    }
  }

  Future<void> fetchData() async {
    _searchController.text = await _phoneService.fetchData();
    phone = _searchController.text;
    await getCurrentUserDetails();
  }

  Future<void> getCurrentUserDetails() async {
    Map<String, dynamic>? currentUserData =
        await _chatService.onSearch(_searchController);
    _searchController.clear();
    setState(() {
      membersList.add(UserData(
        name: currentUserData!['userName'] ?? '',
        email: currentUserData['email'] ?? '',
        number: currentUserData['phone'] ?? '',
        userId: currentUserData['uid'] ?? '',
        gender: currentUserData['gender'] ?? '',
        imageUrl: currentUserData['imageUrl'],
        bio: currentUserData['bio'],
        isAdmin: true,
      ));
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i].number == userMap!['phone']) {
        isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      setState(() {
        membersList.add(UserData(
          name: userMap!['userName'] ?? '',
          email: userMap!['email'] ?? '',
          number: userMap!['phone'] ?? '',
          userId: userMap!['uid'] ?? '',
          gender: userMap!['gender'] ?? '',
          imageUrl: userMap!['imageUrl'],
          bio: userMap!['bio'],
          isAdmin: false,
        ));
        userMap = null;
        _searchController.clear();
      });
      reusableSnackBar(context, 'User added successfully');
    } else {
      reusableSnackBar(context, 'User already exists');
      _searchController.clear();
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index].number != phone) {
      setState(() {
        membersList.remove(membersList[index]);
      });
      reusableSnackBar(
          context, 'User ${membersList[index].name} removed Successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Add Members'),
        ),
        body: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return GroupMemberListTile(
                    userData: membersList[index],
                    onTap: () {
                      onRemoveMembers(index);
                    },
                    icon: Icons.close);
              },
              itemCount: membersList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )),
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
                        onSubmitted: () {}),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 7.h,
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
                      onResultTap();
                    },
                    icon: Icons.add)
                : const Center(
                    child: Text(''),
                  ),
          ],
        ),
        floatingActionButton: membersList.length >= 2
            ? FloatingActionButton(
                tooltip: 'click to proceed',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateGroup(
                                membersList: membersList,
                              )));
                },
                child: const Icon(Icons.forward),
              )
            : FloatingActionButton(
                onPressed: () {
                  reusableSnackBar(context, 'Not enough members');
                },
                tooltip: 'please add more members',
                child: const Icon(Icons.forward),
              ));
  }
}
