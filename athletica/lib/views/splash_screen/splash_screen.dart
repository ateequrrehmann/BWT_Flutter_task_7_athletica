import 'package:athletica/views/links/assets_link/asset_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../onboarding_screen/onboarding_screen.dart';
import '../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLogin = false;
  var auth = FirebaseAuth.instance;
  String? phone;

  Future<void> checkIfLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('user_phone');



    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
    print(isLogin);
  }

  @override
  void initState() {
    super.initState();
    checkIfLogin().then((_) {
      Timer(const Duration(milliseconds: 700), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => phone!=''
                ? const CustomBottomNavigationBar()
                : const OnBoardingScreen(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 35.w,
              height: 35.h,
              child: Image.asset(athletica),
            ),
          ],
        ),
      ),
    );
  }
}
