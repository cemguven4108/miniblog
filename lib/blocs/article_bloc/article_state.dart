import 'package:miniblog/models/blog.dart';

abstract class ArticleState {}

class ArticlesInitial extends ArticleState {}

class ArticlesLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final Blog blog;

  ArticleLoaded({required this.blog});
}

class ArticlesLoaded extends ArticleState {
  final List<Blog> blogs;

  ArticlesLoaded({required this.blogs});
}

class ArticlesError extends ArticleState {}

class ArticlesSuccess extends ArticleState {}