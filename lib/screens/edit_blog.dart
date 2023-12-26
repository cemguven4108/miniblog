import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniblog/services/blog_service.dart';
import 'package:http/http.dart' as http;

class EditBlog extends StatefulWidget {
  const EditBlog({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final blogService = BlogService();
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  XFile? selectedImage;
  String title = "";
  String content = "";
  String author = "";

  submit() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    var request = http.MultipartRequest("POST", url);

    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;

    if (selectedImage != null) {
      http.MultipartFile file = await http.MultipartFile.fromPath("file", selectedImage!.path);
      request.files.add(file);
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

  pickImage() async {
    final selectedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      selectedImage = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Editing"),
      ),
      body: FutureBuilder(
        future: blogService.fetchBlog(
          Uri.parse(
              "https://tobetoapi.halitkalayci.com/api/Articles/${widget.id}"),
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Image.network(blog.thumbnail),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Fotograf Sec")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
