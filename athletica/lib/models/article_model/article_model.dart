import 'package:athletica/models/article_model/sub_heading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Subheading> subheadings;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.subheadings,
  });

  factory Article.fromDocument(DocumentSnapshot doc) {
    var subheadingList = (doc['subheadings'] as List).map((item) {
      return Subheading(
        title: item['title'],
        details: item['details'],
        imageUrl: item['imageUrl'],
      );
    }).toList();

    return Article(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      subheadings: subheadingList,
    );
  }
}
