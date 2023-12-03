import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_api_integration/state/post_state.dart';
import 'package:riverpod_api_integration/utils/utils.dart';

class HomeViewWidget extends ConsumerWidget {
  const HomeViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PostState>(postProvider, (previousState, newState) {
      // React to changes in the state here

      if (newState is ErrorPostState) {
        Utils.snackBar(newState.message.toString(), context);
      }
    });
    BuildContext currentContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.forward),
          onPressed: () {
            ref.read(postProvider.notifier).fetchProduct(currentContext);
          },
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                context.go('/signup');
              },
              icon: const Icon(
                Icons.forward,
              ),
            )
          ],
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              PostState state = ref.watch(postProvider);
              if (state is InitialPostState) {
                return const Text('Please press the button');
              }
              if (state is PostLoadingPostState) {
                return const CircularProgressIndicator();
              }
              if (state is ErrorPostState) {
                return const Text('error');
              }
              if (state is PostLoadedPostState) {
                return _buildListView(state);
              }

              return const Text('State not found');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView(PostLoadedPostState state) {
    return ListView.builder(
      itemCount: state.postList.length,
      itemBuilder: (context, index) {
        var post = state.postList[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              post.id.toString(),
            ),
          ),
          title: Text(
            post.title.toString(),
          ),
        );
      },
    );
  }
}
