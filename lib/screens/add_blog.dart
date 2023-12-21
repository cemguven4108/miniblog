import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
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
    final selectedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (selectedImage != null)
                Image.file(File(selectedImage!.path)),
              ElevatedButton(
                onPressed: () => pickImage(),
                child: Text("Fotograf sec"),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("blog basligi"),
                ),
                onSaved: (newValue) {
                  title = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lutfen bir blog basligi giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Blog icerigi"),
                ),
                maxLines: 5,
                onSaved: (newValue) {
                  content = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lutfen bir blog icerigi giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Ad soyad"),
                ),
                onSaved: (newValue) {
                  author = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lutfen adsoyad giriniz";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    submit();
                  }
                },
                child: const Text("Blog ekle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
