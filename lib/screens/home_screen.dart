import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miniblog/models/blog.dart';
import 'package:miniblog/screens/add_blog.dart';
import 'package:miniblog/services/blog_service.dart';
import 'package:miniblog/widgets/blog_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final blogService = BlogService();
  List<Blog> blogList = [];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    List<Blog> blogs = await blogService.fetchBlogs(
      Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles"),
    );
    blogList.addAll(blogs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Blog Listesi"),
        actions: [
          IconButton(
            onPressed: () async {
              bool? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddBlog()),
              );

              if (result == true) {
                blogList.clear();
                _initState();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: blogList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                blogList.clear();
                _initState();
              },
              child: ListView.builder(
                itemCount: blogList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(blogList[index].id),
                    onDismissed: (_) {
                      blogService.deleteBlog(
                        Uri.parse(
                          "https://tobetoapi.halitkalayci.com/api/Articles/${blogList[index].id}",
                        ),
                      );
                    },
                    child: BlogItem(blog: blogList[index]),
                  );
                },
              ),
            ),
    );
  }
}
