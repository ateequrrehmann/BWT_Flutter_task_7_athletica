
import 'package:athletica_admin/views/article/article_screen/widget/article_card.dart';
import 'package:athletica_admin/views/new_article_screen/new_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../provider/future_provider/article_provider/article_provider.dart';
import '../../color/colors.dart';
import '../article_detail_screen/article_detail_screen.dart';

class ArticlesScreen extends ConsumerWidget {
  final String title;

  const ArticlesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final articles = ref.watch(articlesProvider(title));
    ref.invalidate(articlesProvider(title));

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: articles.when(
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
                        builder: (context) => ArticleDetail(title: title, details: article,),
                      ),
                    );
                  },
                  child: ArticleCard(size: size, article: article, title: title)
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NewArticleScreen(title: title)));
    }, child: Icon(Icons.add),),
    );

  }
}
