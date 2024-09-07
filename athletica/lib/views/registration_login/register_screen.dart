import 'package:athletica/views/links/assets_link/asset_link.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:athletica/views/registration_login/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../provider/state_notifier_provider/user_provider.dart';
import '../../services/auth_service/auth_service.dart';
import '../widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneValid = false;
  String completePhoneNumber = '';
  bool isLoading = false;
  final AuthService _authService = AuthService();

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void navigateToOtpScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OtpForm()));
  }

  void navigateToUserDetailScreen() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const UserDetailScreen()));
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Welcome to Athletica',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: darkOrange),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Register by entering your phone number',
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: size.width,
                height: 33.h,
                child: Image.asset(athleticaLogo),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    IntlPhoneField(
                      controller: _phoneController,
                      initialCountryCode: 'PK',
                      onChanged: (phone) {
                        setState(() {
                          completePhoneNumber = phone.completeNumber;
                          _isPhoneValid = completePhoneNumber.isNotEmpty;
                        });
                      },
                      onCountryChanged: (country) {
                      },
                      decoration: InputDecoration(
                          labelText: "XXXXXXXXXX",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: textFieldColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.w),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none))),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Consumer(builder: (context, ref, child) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 7.h,
                        margin: EdgeInsets.fromLTRB(0, 1.h, 0, 2.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.w)),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _isPhoneValid) {
                              ref
                                  .read(userProvider.notifier)
                                  .updateNumber(completePhoneNumber);
                              await _authService.registerUser(
                                completePhoneNumber,
                                context,
                                setLoading,
                                navigateToOtpScreen,
                                navigateToUserDetailScreen,
                              );
                            } else {
                              if (!_isPhoneValid) {
                                reusableSnackBar(
                                    context, 'Phone number can\'t be empty');
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(darkOrange),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(2.w)))),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: circularProgressColor,
                                )
                              : Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp),
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
