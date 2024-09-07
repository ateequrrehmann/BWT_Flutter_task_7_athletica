import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/profile_screen/profile_screen.dart';
import '../../views/widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../views/widgets/reusable_snack_bar/reusable_snack_bar.dart';

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;



  Future<void> registerUser(
      String completePhoneNumber,
      context,
      Function setLoading,
      Function navigateToOtpScreen,
      Function navigateToUserDetailScreen,
      )async{

    setLoading(true);

    DocumentSnapshot documentSnapshot =
    await _firestore
        .collection('users')
        .doc(completePhoneNumber)
        .get();

    if (documentSnapshot.exists == true &&
        completePhoneNumber != '+923099286884') {
      try {
        navigateToOtpScreen();
        // await _auth.verifyPhoneNumber(
        //     phoneNumber: completePhoneNumber,
        //     verificationCompleted:
        //         (PhoneAuthCredential credential) {},
        //     verificationFailed:
        //         (FirebaseAuthException e) {
        //       reusableSnackBar(context,
        //           '${e.message!} Verification failed');
        //     },
        //     codeSent: (String verificationId,
        //         int? resendToken) async {
        //       SharedPreferences prefs =
        //       await SharedPreferences
        //           .getInstance();
        //       prefs.setString(
        //           'verification_id', verificationId);
        //       prefs.setString('admin_phone', '');
        //
        //       navigateToOtpScreen();
        //     },
        //     codeAutoRetrievalTimeout:
        //         (String verificationId) {
        //       // _dismissLoadingDialog(context);
        //     });
      } catch (e) {
        setLoading(false);

      }
    }
    else if (documentSnapshot.exists == false &&
        completePhoneNumber != '+923099286884') {
      try{
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.setString('admin_phone', '');

        navigateToUserDetailScreen();
      }
      catch(e){
        setLoading(false);
      }
    }

  }




  Future<void> verifyUser(BuildContext context, String code, String name, String phone,
      String email, String image, String gender, bool isLoading, VoidCallback onLoadingChanged) async {


    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // String? verificationId=prefs.getString('verification_id');

    onLoadingChanged();

    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: verificationId!, smsCode: code);
      // UserCredential usercredential=await _auth.signInWithCredential(credential);





        DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(phone)
            .get();

        if(documentSnapshot.exists==false && code=='123456'){
          await FirebaseFirestore.instance
              .collection('users')
              .doc(phone)
              .set({
            'userName': name,
            'phone': phone,
            'email': email,
            'user_id': '',
            'imageUrl': image,
            'gender': gender,
            'bio': 'Empty Bio'
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_phone', phone);

          if(context.mounted){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileScreen()));
          }

        }
        else if (documentSnapshot.exists && code=='123456'){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_phone', phone);
          if(context.mounted){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const CustomBottomNavigationBar()));
          }
        }


    } catch (e) {
      onLoadingChanged();
      if(context.mounted){
        reusableSnackBar(context, "Invalid OTP");
      }
    }
  }
}
