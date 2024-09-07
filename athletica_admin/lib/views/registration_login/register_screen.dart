import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../services/auth_service/auth_service.dart';
import '../color/colors.dart';
import '../links/assets_link/asset_link.dart';
import '../widgets/reusable_snack_bar.dart';
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
        context,
        MaterialPageRoute(
            builder: (context) => OtpForm(
                  phone: completePhoneNumber,
                )));
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
                      onCountryChanged: (country) {},
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 7.h,
                      margin: EdgeInsets.fromLTRB(0, 1.h, 0, 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.w)),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _isPhoneValid) {
                            await _authService.registerUser(
                              completePhoneNumber,
                              context,
                              setLoading,
                              navigateToOtpScreen,
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
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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
                    ),
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
