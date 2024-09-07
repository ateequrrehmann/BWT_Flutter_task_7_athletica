import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey : Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: ListTile(
          title: Text(title),
          leading: Icon(icon),
          onTap: onTap,
        ),
      ),
    );
  }
}
