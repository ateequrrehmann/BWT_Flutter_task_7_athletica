import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class CreateGroup extends StatefulWidget {
  final List<UserData> membersList;

  const CreateGroup({super.key, required this.membersList});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void createGroup() async {
    setState(() {
      isLoading = true;
    });

   _chatService.createGroup(_groupNameController.text, widget.membersList);

    reusableSnackBar(context, 'Group Created Successfully');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBar()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Group Name'),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 7.w,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white30,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              hintText: "Name",
                              prefixIcon: const Icon(
                                Icons.search,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 2.w),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Group Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 7.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      createGroup();
                    }
                  },
                  child: const Text('Create Group'),
                )
              ],
            ),
    );
  }
}
