import 'dart:convert';

import 'package:miniblog/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogService {
  Future<List<Blog>> fetchBlogs(Uri url) async {
    final response = await http.get(url);
    final jsonData = json.decode(response.body) as List<dynamic>;

    return jsonData.map((map) {
      return Blog.fromJson(map);
    }).toList();
  }

  Future<Blog> fetchBlog(Uri url) async {
    final response = await http.get(url);
    final jsonData = json.decode(response.body) as Map<String, Object?>;

    return Blog.fromJson(jsonData);
  }

  Future<bool> deleteBlog(Uri url) async {
    final response = await http.delete(url);

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
