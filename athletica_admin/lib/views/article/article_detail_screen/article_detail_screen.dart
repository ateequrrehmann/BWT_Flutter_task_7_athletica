import 'package:athletica_admin/views/article/article_detail_screen/widget/edit_alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../../models/article_model/article_model.dart';
import '../../../services/article_service/article_service.dart';

class ArticleDetail extends StatefulWidget {
  final String title;
  final Article details;

  const ArticleDetail({super.key, required this.title, required this.details});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final ArticleService _articleService = ArticleService();
  late Article _articleDetails;
  late Map<String, dynamic> article;

  @override
  void initState() {
    super.initState();
    _articleDetails = widget.details;
    article = _articleDetails.toMap();
  }

  Future<void> editSection(String section, String initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) => EditAlertDialog(
        section: section,
        controller: controller,
      ),
    );

    if (newValue != null) {
      setState(() {
        article[section] = newValue;
        _articleService.updateArticle(article, widget.title);
      });
    }
  }

  Future<void> editSubheading(
      String field, Map<String, dynamic> subheading) async {
    TextEditingController controller =
        TextEditingController(text: subheading[field]);

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) => EditAlertDialog(
        section: field,
        controller: controller,
      ),
    );
    if (newValue != null) {
      setState(() {
        int index = article['subheadings'].indexOf(subheading);
        article['subheadings'][index][field] = newValue;
        _articleService.updateArticle(article, widget.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_articleDetails.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                Center(child: Image.network(article['imageUrl'])),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle image editing logic here
                    _articleService.editImage(
                        'imageUrl', null, article, widget.title);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    article['title'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editSection('title', article['title']);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    article['description'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editSection('description', article['description']);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...article['subheadings'].map<Widget>((subheading) {
              int index = article['subheadings'].indexOf(subheading);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subheading['title'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editSubheading('title', subheading);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(subheading['details']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editSubheading('details', subheading);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (subheading['imageUrl'] != null)
                    Column(
                      children: [
                        Center(child: Image.network(subheading['imageUrl'])),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Handle image editing logic here
                            _articleService.editImage(
                                'subheadings[$index].imageUrl',
                                null,
                                article,
                                widget.title);
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 16.0),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
