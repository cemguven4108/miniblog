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
  final _scrollController = ScrollController();
  bool atBottom = false;

  void _scroll() {
    if (!atBottom) {
      setState(() {
        atBottom = true;
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } else {
      setState(() {
        atBottom = false;
      });
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  Future<void> _refresh() async {
    return await Future(
      () => context.read<ArticleBloc>().add(FetchArticles()),
    );
  }

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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<ArticleBloc, ArticleState>(
          buildWhen: (previous, current) =>
              previous != current && current is ArticlesLoaded,
          builder: (context, state) {
            if (state is ArticlesError) {
              return const Center(
                child: Text("Hata!"),
              );
            }

            if (state is! ArticlesLoaded) {
              context.read<ArticleBloc>().add(FetchArticles());

              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(state.blogs[index].id),
                  onDismissed: (direction) {
                    context.read<ArticleBloc>().add(
                          DeleteArticle(id: state.blogs[index].id),
                        );
                    _refresh();
                  },
                  child: BlogItem(
                    blog: state.blogs[index],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _scroll,
        child: atBottom
            ? const Icon(Icons.arrow_upward)
            : const Icon(
                Icons.arrow_downward,
              ),
      ),
    );
  }
}
