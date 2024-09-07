import 'package:athletica/views/color/colors.dart';
import 'package:athletica/services/profile_service/profile_service.dart';
import 'package:athletica/views/profile_screen/widget/edit_alert_dialog.dart';
import 'package:athletica/views/profile_screen/widget/profile_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:typed_data';
import '../../models/user_data/user_data.dart';
import '../../provider/future_provider/profile_screen_provider/profile_screen_provider.dart';
import '../links/image_link/image_link.dart';
import '../widgets/custom_drawer/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  final ProfileService _profileService=ProfileService();
  final EditAlertDialog _editAlertDialog=EditAlertDialog();


  String selectedTile = 'PROFILE';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final data = ref.watch(userFirebaseProvider);
      return data.when(data: (user) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: ListView(
            children: [
              SizedBox(height: 5.h),
              Center(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 17.w,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : user.imageUrl !=''
                        ? CircleAvatar(
                      radius: 17.w,
                      backgroundImage:
                      NetworkImage('${user.imageUrl}'),
                    )
                        : CircleAvatar(
                      radius: 17.w,
                      backgroundImage: NetworkImage('${user.imageUrl}'),
                    ),
                    Positioned(
                      bottom: -1.5.h,
                      left: 19.w,
                      child: IconButton(
                        onPressed: () async {
                          Uint8List? img = await _profileService.pickImage(
                              ImageSource.gallery, context);
                          if(img!=null){
                            setState(() {
                              _image = img;
                            });
                            await _profileService.updateUserProfileImage(img, user.number);
                            ref.invalidate(userFirebaseProvider);
                          }

                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 3.h),
               Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Text(
                  'My Details',
                  style: TextStyle(color: profileTextColor, fontSize: 18.sp),
                ),
              ),
              SizedBox(height: 3.h),
              ProfileDetailItem(label: "UserName",value: user.name, onPressed: ()async{
                String newValue = await _editAlertDialog.editDialog(context, 'Name');

                if (newValue.trim().isNotEmpty) {
                  _profileService.updateUserName(user.number, newValue);
                  ref.invalidate(userFirebaseProvider);
                }
              }),
              ProfileDetailItem(label: "Phone",value: user.number, onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("can't change the phone number"),
                  ),
                );
              }),
              ProfileDetailItem(label: "Bio", value: user.bio!, onPressed: () async {
                String newValue = await _editAlertDialog.editDialog(context, 'Bio');
                if (newValue.trim().isNotEmpty) {
                  _profileService.updateUserBio(user.number, newValue);
                  ref.invalidate(userFirebaseProvider);
                }
              }),
              ProfileDetailItem(label: "Email", value: user.email, onPressed: () async {
                String newValue = await _editAlertDialog.editDialog(context, 'Email');

                if (newValue.trim().isNotEmpty) {
                  _profileService.updateUserEmail(user.number, newValue);
                  ref.invalidate(userFirebaseProvider);

                }

              }),
            ],
          ),
          drawer: CustomDrawer(selectedTile: selectedTile, onItemSelected: (String selected){
            setState(() {
              selectedTile = selected;
            });
          }, user: user),
        );
      }, error: (error, track) {
        return Center(child: Text('checking+$error'));
      }, loading:() {
        return CustomDrawer(
            selectedTile: selectedTile,
            onItemSelected: (String selected) {
              selectedTile = selected;
            },
            user: const UserData(
                name: '', email: '', number: '', userId: '', gender: '', imageUrl: image));
      },);
    });
  }
}
