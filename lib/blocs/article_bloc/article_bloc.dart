import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';
import 'package:miniblog/blocs/article_bloc/article_state.dart';
import 'package:miniblog/repositories/article_repository.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository articleRepository;

  ArticleBloc({required this.articleRepository}) : super(ArticlesInitial()) {
    on<FetchArticles>(_onFetchAll);
    on<AddArticle>(_onAdd);
    on<DeleteArticle>(_onDelete);
  }

  void _onFetchAll(FetchArticles event, Emitter<ArticleState> emit) async {
    emit(ArticlesLoading());

    final blogList = await articleRepository.fetchBlogs();
    
    emit(ArticlesLoaded(blogs: blogList));
  }

  void _onAdd(AddArticle event, Emitter<ArticleState> emit) async {
    final response = await articleRepository.addBlog(
      event.title,
      event.content,
      event.author,
      event.file,
    );

    if (!response) {
      emit(ArticlesError());
    }
    emit(ArticlesSuccess());
  }

  void _onDelete(DeleteArticle event, Emitter<ArticleState> emit) async {
    final response = await articleRepository.deleteBlog(
      event.id,
    );

    if (!response) {
      emit(ArticlesError());
    }
    emit(ArticlesSuccess());
  }
}
