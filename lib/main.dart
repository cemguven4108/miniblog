import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/repositories/article_repository.dart';
import 'package:miniblog/screens/home_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ArticleBloc(
        articleRepository: ArticleRepository(),
      ),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const HomeScreen(),
      ),
    ),
  );
}
