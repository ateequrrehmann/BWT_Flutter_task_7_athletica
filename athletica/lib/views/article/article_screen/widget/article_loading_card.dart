import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArticleLoadingCard extends StatelessWidget {
  const ArticleLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            padding: EdgeInsets.all(2.w),
            width: double.infinity,
            height: size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.w)),
              shape: BoxShape.rectangle ,
              color: Theme.of(context).primaryColor.withOpacity(0.06),
            ),
          ),
          // Title and Description
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: size.width,
                  height: size.width*0.1,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.all(Radius.circular(2.w))
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.width*0.3,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.all(Radius.circular(2.w))
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
