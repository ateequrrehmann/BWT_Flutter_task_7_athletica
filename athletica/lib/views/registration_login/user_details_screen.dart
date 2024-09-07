import 'package:athletica/views/links/assets_link/asset_link.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/state_notifier_provider/user_provider.dart';
import '../links/image_link/image_link.dart';
import '../widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'widget/reusable_text_form_field.dart';
import 'otp_screen.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String gender = 'Male';
  final _formKey = GlobalKey<FormState>();
  var _valueRadio = 1;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(7.w, 12.h, 7.w, 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                width: size.width,
                height: 25.h,
                child: Image.asset(athleticaLogo),
              ),
              SizedBox(height: 1.5.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableTextFormField(text: "Name", icon: Icons.person, controller: _nameController, check: true),
                    SizedBox(height: 5.h),
                    ReusableTextFormField(text: "Email", icon: Icons.email, controller: _emailController, check: false),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select gender",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Male"),
                            value: 1,
                            groupValue: _valueRadio,
                            onChanged: (value) {
                              setState(() {
                                _valueRadio = value!;
                                gender = "Male";
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Female"),
                            value: 2,
                            groupValue: _valueRadio,
                            onChanged: (value) {
                              setState(() {
                                _valueRadio = value!;
                                gender = "Female";
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Consumer(builder: (context, ref, child) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 7.h,
                        margin: EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.w)),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ref.watch(userProvider.notifier).updateName(_nameController.text);
                              ref.watch(userProvider.notifier).updateEmail(_emailController.text);
                              ref.watch(userProvider.notifier).updateGender(gender);
                              ref.watch(userProvider.notifier).updateImageUrl(image);
                              final completePhoneNumber = ref.watch(userProvider.select((value) => value.number));
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: completePhoneNumber,
                                    verificationCompleted: (PhoneAuthCredential credential) {},
                                    verificationFailed: (FirebaseAuthException e) {
                                      reusableSnackBar(context, '${e.message!} Verification failed');
                                    },
                                    codeSent: (String verificationId, int? resendToken) async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('verification_id', verificationId);
                                      if(context.mounted){
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(builder: (context) => const OtpForm()));
                                      }
                                    },
                                    codeAutoRetrievalTimeout: (String verificationId) {});
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } else {}
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(darkOrange),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)))),
                          child: isLoading
                              ? const CircularProgressIndicator(color: circularProgressColor)
                              :  Text(
                            'Register',
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 17.sp),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
