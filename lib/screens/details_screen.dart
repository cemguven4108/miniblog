import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';
import 'package:miniblog/blocs/article_bloc/article_state.dart';
import 'package:miniblog/screens/edit_blog.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditBlog(id: id)));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticlesInitial || state is ArticlesLoaded || state is ArticlesSuccess) {
            context.read<ArticleBloc>().add(FetchArticle(id: id));
          }

          if (state is ArticlesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ArticlesError) {
            return const Center(
              child: Text("Error"),
            );
          }

          if (state is ArticleLoaded) {
            final blog = state.blog;

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
          }

          return const Center(
            child: Text("Unknown"),
          );
        },
      ),
    );
  }
}
