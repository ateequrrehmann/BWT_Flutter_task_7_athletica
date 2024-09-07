import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/article_model/article_model.dart';

final articlesProvider = FutureProvider.family<List<Article>,String>((ref, collection) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final querySnapshot = await firestore.collection(collection).get();

    final articles = querySnapshot.docs.map((doc) {
      return Article.fromDocument(doc);
    }).toList();

    return articles;
  } catch (e) {
    throw Exception('Failed to load articles: $e');
  }
});
