import 'package:athletica_admin/views/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/widgets/reusable_snack_bar.dart';

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
    String completePhoneNumber,
    context,
    Function setLoading,
    Function navigateToOtpScreen,
  ) async {
    setLoading(true);

    DocumentSnapshot adminDocumentSnapshot =
        await _firestore.collection('admin').doc(completePhoneNumber).get();

    if (adminDocumentSnapshot.exists == true &&
        completePhoneNumber == '+923099286884') {
      try {
        navigateToOtpScreen();
        // await FirebaseAuth.instance.verifyPhoneNumber(
        //     phoneNumber: completePhoneNumber,
        //     verificationCompleted: (PhoneAuthCredential credential) {},
        //     verificationFailed: (FirebaseAuthException e) {
        //       reusableSnackBar(context, '${e.message!} Verification failed');
        //     },
        //     codeSent: (String verificationId, int? resendToken) async {
        //       SharedPreferences prefs = await SharedPreferences.getInstance();
        //       prefs.setString('verification_id', verificationId);
        //       prefs.setString('admin_phone', completePhoneNumber);
        //       navigateToOtpScreen();
        //     },
        //     codeAutoRetrievalTimeout: (String verificationId) {
        //       // _dismissLoadingDialog(context);
        //     });
      } catch (e) {
        setLoading(false);
      }
    }
    else{
      if(context.mounted){
        reusableSnackBar(context, "Wrong number");
        setLoading(false);
      }
    }
  }

  Future<void> verifyUser(
      BuildContext context,
      String code,
      bool isLoading,
      VoidCallback onLoadingChanged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? adminPhone = prefs.getString('admin_phone');

    onLoadingChanged();

    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: verificationId!, smsCode: code);
      // UserCredential usercredential =
      //     await _auth.signInWithCredential(credential);

      if (adminPhone == '+923099286884' && code=='123456') {
        await FirebaseFirestore.instance
            .collection('admin')
            .doc(adminPhone)
            .set({
          'userName': 'Ateeq',
          'phone': adminPhone,
          'email': 'rehmanateequr501@gmail.com',
          'user_id': '',
          'imageUrl': '',
          'gender': 'Male',
        });
        if (context.mounted){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage()));
        }

      }

    } catch (e) {
      onLoadingChanged();
      if (context.mounted){
        reusableSnackBar(context, "Invalid OTP");
      }
    }
  }
}
