import 'package:athletica/models/article_model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArticleCard extends StatelessWidget {
  final Size size;
  final Article article;
  const ArticleCard({super.key, required this.size, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: double.infinity,
            height: size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.w)),
              image: DecorationImage(
                image: NetworkImage(article.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Title and Description
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 1.5.h),
                // Description
                Text(
                  article.description,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 3, // Limit number of lines for description
                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
