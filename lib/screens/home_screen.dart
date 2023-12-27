import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_bloc.dart';
import 'package:miniblog/blocs/article_bloc/article_event.dart';
import 'package:miniblog/blocs/article_bloc/article_state.dart';
import 'package:miniblog/screens/add_blog.dart';
import 'package:miniblog/widgets/blog_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog Listesi"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => const AddBlog()));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticlesInitial || state is ArticlesSuccess) {
            context.read<ArticleBloc>().add(FetchArticles());

            return const Center(
              child: Text("istek atiliyor"),
            );
          }

          if (state is ArticlesLoaded) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(state.blogs[index].id),
                  onDismissed: (direction) => context.read<ArticleBloc>().add(
                        DeleteArticle(id: state.blogs[index].id),
                      ),
                  child: BlogItem(
                    blog: state.blogs[index],
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("bilinmedik durum"),
          );
        },
      ),
    );
  }
}
