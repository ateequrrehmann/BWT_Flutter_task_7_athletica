class Subheading {
  final String title;
  final String details;
  final String imageUrl;

  Subheading({
    required this.title,
    required this.details,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'details': details, 'imageUrl': imageUrl};
  }
}
