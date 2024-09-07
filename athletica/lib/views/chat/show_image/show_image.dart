import 'package:flutter/material.dart';

import '../../color/colors.dart';

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: imageContainerColor,
        child: Image.network(imageUrl),
      ),
    );
  }
}