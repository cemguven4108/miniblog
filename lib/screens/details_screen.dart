import 'package:flutter/material.dart';
import 'package:miniblog/services/blog_service.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    final blogService = BlogService();

    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Details"),
      ),
      body: FutureBuilder(
        future: blogService.fetchBlog(
          Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles/$id"),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "No Data!!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blog = snapshot.requireData;

          return Padding(
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
          );
        },
      ),
    );
  }
}
