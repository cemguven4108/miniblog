import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:miniblog/models/blog.dart';
import 'package:http/http.dart' as http;

class ArticleRepository {
  Future<Blog> fetchBlog(String id) async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles/$id");
    final response = await http.get(url);
    final Map<String, Object?> jsonData = json.decode(response.body);
    return Blog.fromJson(jsonData);
  }

  Future<List<Blog>> fetchBlogs() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    final response = await http.get(url);
    final List jsonData = json.decode(response.body);
    return jsonData.map((json) => Blog.fromJson(json)).toList();
  }

  Future<bool> addBlog(
    String title,
    String content,
    String author,
    XFile file,
  ) async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    var request = http.MultipartRequest("POST", url);

    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;

    final image = await http.MultipartFile.fromPath("file", file.path);
    request.files.add(image);

    final response = await request.send();

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> deleteBlog(String id) async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles/$id");
    final response = await http.delete(url);

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
