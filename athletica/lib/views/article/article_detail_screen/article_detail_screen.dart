import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/article_model/article_model.dart';
class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: EdgeInsets.all(3.w),
        child: ListView(
          children: [
            Image.network(article.imageUrl),
            SizedBox(height: 1.5.h),
            Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 1.5.h),
            Text(article.description, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.5.h),
            ...article.subheadings.map((subheading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subheading.title, style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 1.5.h),
                  Text(subheading.details),
                  SizedBox(height: 1.5.h),
                  Center(child: Image.network(subheading.imageUrl)),
                  SizedBox(height: 1.5.h),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
