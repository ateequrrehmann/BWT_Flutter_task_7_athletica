import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController searchController;
  final IconData icon;
  final VoidCallback onSubmitted;
  const ChatTextField({super.key, required this.searchController, required this.icon, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search by phone number",
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.w),
        ),
      ),
      onSubmitted: (value) {
        onSubmitted();
      },
    );
  }
}
