
import 'package:athletica/views/article/article_screen/widget/article_card.dart';
import 'package:athletica/views/article/article_screen/widget/article_loading_card.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../provider/future_provider/article_provider/article_provider.dart';
import '../article_detail_screen/article_detail_screen.dart';


class ArticlesScreen extends ConsumerWidget {
  final String title;

  const ArticlesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final articlesValue = ref.watch(articlesProvider(title));

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: articlesValue.when(
        data: (articles) {
          return Padding(
            padding: EdgeInsets.all(2.w),
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                  child: ArticleCard(size: size, article: article)
                );
              },
            ),
          );
        },
        loading: () {
            return const ArticleLoadingCard();
          },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
