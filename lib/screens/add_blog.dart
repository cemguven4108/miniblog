import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';

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

  pickImage() async {
    final selectedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (selectedImage != null) Image.file(File(selectedImage!.path)),
              ElevatedButton(
                onPressed: () => pickImage(),
                child: const Text("Fotograf sec"),
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

                    if (selectedImage != null) {
                      context.read<ArticleBloc>().add(AddArticle(
                            title: title,
                            content: content,
                            author: author,
                            file: selectedImage!,
                          ));
                    }

                    Navigator.of(context).pop();
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
