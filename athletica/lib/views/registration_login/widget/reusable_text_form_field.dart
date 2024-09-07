import 'package:athletica/views/color/colors.dart';
import 'package:flutter/material.dart';


class ReusableTextFormField extends StatefulWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;
  final bool check;

  const ReusableTextFormField(
      {super.key,
      required this.text,
      required this.icon,
      required this.controller,
      required this.check});

  @override
  State<ReusableTextFormField> createState() => _ReusableTextFormFieldState();
}

class _ReusableTextFormFieldState extends State<ReusableTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: false,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: Colors.black,
      validator: widget.check
          ? (value) {
              if (value == null || value.isEmpty) {
                return "${widget.text} can't be empty";
              } else {
                return null;
              }
            }
          : (value) {
              if (value == null || value.isEmpty) {
                return "${widget.text} can't be empty";
              } else if (widget.text.toLowerCase() == 'email' &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email address";
              } else {
                return null;
              }
            },
      style: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: Icon(
            widget.icon,
            color: darkOrange,
          ),
          labelText: "Enter your ${widget.text}",
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(0.9),
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: textFieldColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );
  }
}
