import 'package:athletica/services/auth_service/auth_service.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../provider/state_notifier_provider/user_provider.dart';
import '../links/image_link/image_link.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService authService = AuthService();
  bool isLoading = false;
  String? code;
  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: textColor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ));

  final focusedPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: textColor),
      decoration: BoxDecoration(
        color: darkOrange,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ));

  final submittedPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: textColor),
      decoration: BoxDecoration(
        color: darkOrange,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Consumer(builder: (context, ref, child) {
            final phone =
                ref.watch(userProvider.select((value) => value.number));
            final name = ref.watch(userProvider.select((value) => value.name));
            final email =
                ref.watch(userProvider.select((value) => value.email));
            final gender =
                ref.watch(userProvider.select((value) => value.gender));



            return Column(
              children: [
                 Text(
                  'OTP Verification',
                  style: TextStyle(
                      color: otpBlack,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  child: Text(
                    'Enter the code sent to your number',
                    style: TextStyle(color: otpBlack, fontSize: 18.sp),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    phone,
                    style: TextStyle(color: paleBlue, fontSize: 17.sp),
                  ),
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onCompleted: (pin) {
                    code = pin;
                    isLoading
                        ? null
                        : authService.verifyUser(
                            context,
                            pin,
                            name,
                            phone,
                            email,
                            image,
                            gender,
                            isLoading,
                            () => setState(() {
                                  isLoading = !isLoading;
                                }));
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 7.h,
                  margin: EdgeInsets.fromLTRB(0, 1.h, 0, 2.h),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(2.w)),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => authService.verifyUser(
                            context,
                            code!,
                            name,
                            phone,
                            email,
                            image,
                            gender,
                            isLoading,
                            () => setState(() {
                                  isLoading = !isLoading;
                                })),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(darkOrange),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w)))),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: circularProgressColor,
                          )
                        :  Text(
                            'Verify',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.sp),
                          ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

}
