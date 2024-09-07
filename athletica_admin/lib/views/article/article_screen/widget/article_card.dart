import 'package:athletica_admin/services/article_service/article_service.dart';
import 'package:athletica_admin/views/widgets/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/article_model/article_model.dart';


class ArticleCard extends StatefulWidget {
  final Size size;
  final Article article;
  final String title;

  const ArticleCard(
      {super.key,
      required this.size,
      required this.article,
      required this.title});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  final ArticleService _articleService = ArticleService();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: double.infinity,
            height: widget.size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.w)),
              image: DecorationImage(
                image: NetworkImage(widget.article.imageUrl),
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
                  widget.article.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 1.5.h),
                // Description
                Text(
                  widget.article.description,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 3, // Limit number of lines for description
                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (_articleService.onDeleteArticle(
                              widget.title, widget.article.id)) {
                            reusableSnackBar(context, 'Deleted Successfully');
                          } else {
                            reusableSnackBar(context, 'Failed to delete');
                          }
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
