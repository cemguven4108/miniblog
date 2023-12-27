import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';
import 'package:miniblog/screens/details_screen.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({
    Key? key,
    required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 2,
              child: Image.network(blog.thumbnail),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(blog: blog),
                  ),
                );
              },
              title: Text(blog.title),
              subtitle: Text(blog.author),
            ),
          ],
        ),
      ),
    );
  }
}
