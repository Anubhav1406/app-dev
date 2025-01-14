import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String content;
  final String url;

  ArticleDetailScreen({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Text(url),
          ],
        ),
      ),
    );
  }
}