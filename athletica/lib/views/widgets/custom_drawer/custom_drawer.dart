import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/views/widgets/custom_drawer/widget/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../color/colors.dart';
import '../../profile_screen/profile_screen.dart';
import '../../registration_login/register_screen.dart';
import '../custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';


class CustomDrawer extends StatelessWidget {
  final String selectedTile;
  final Function(String) onItemSelected;
  final UserData user;

  const CustomDrawer(
      {super.key,
      required this.selectedTile,
      required this.onItemSelected,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 70. w,
      backgroundColor: primaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: darkOrange,
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: darkOrange,
              ),
              accountName: Text(
                user.name,
                style: TextStyle(fontSize: 17.sp),
              ),
              accountEmail: Text(
                user.number,
              ),
              currentAccountPictureSize: Size.square(12.w),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user.imageUrl != ''
                    ? NetworkImage('${user.imageUrl}')
                    : null,
              ),
            ),
          ),
          DrawerItem(
              title: 'H O M E',
              icon: Icons.home,
              isSelected: selectedTile == 'HOME',
              onTap: () {
                onItemSelected('HOME');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomBottomNavigationBar(),
                  ),
                );
              }),
          DrawerItem(
              title: 'P R O F I L E',
              icon: Icons.person,
              isSelected: selectedTile == 'PROFILE',
              onTap: () {
                onItemSelected('PROFILE');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('verification_id', '');
                prefs.setString('user_phone', '');
                // FirebaseAuth.instance.signOut();
                if(context.mounted){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
