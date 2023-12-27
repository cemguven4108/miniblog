import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 2,
              child: Image.network(blog.thumbnail),
            ),
            Card(
              child: ListTile(
                title: Text(
                  "Title : ${blog.title}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  "Author : ${blog.author}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: ListTile(
                  title: Text(blog.content),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
