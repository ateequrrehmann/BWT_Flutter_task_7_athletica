

import 'package:flutter/material.dart';

import '../../registration_login/register_screen.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFF5733), borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 55,
      child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
          },
          child: const Text(
            'Get Started',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
