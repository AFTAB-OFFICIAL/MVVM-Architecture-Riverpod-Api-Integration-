import 'package:flutter/material.dart';
import 'package:riverpod_api_integration/repository/http_get_service.dart';
import 'package:riverpod_api_integration/utils/utils.dart';
import 'package:state_notifier/state_notifier.dart';
import '../models/post_model.dart';
import 'package:riverpod/riverpod.dart';

final postProvider =
    StateNotifierProvider<PostsNotifier, PostState>((ref) => PostsNotifier());
    

@immutable
abstract class PostState {}

class InitialPostState extends PostState {}

class PostLoadingPostState extends PostState {}

class PostLoadedPostState extends PostState {
  PostLoadedPostState({required this.postList});
  final List<Post> postList;
}

class ErrorPostState extends PostState {
  ErrorPostState({required this.message});

  final String message;
}

//  StateNotifier mae hum upar wali States Use krengye
class PostsNotifier extends StateNotifier<PostState> {  
  PostsNotifier() : super(InitialPostState());
  final HttpGetServices _httpPost = HttpGetServices();

  fetchProduct(currentContext) async {
    try {
      state = PostLoadingPostState();
      List<Post> postList = await _httpPost.getPost();
      state = PostLoadedPostState(postList: postList);
    } catch (e) {
      print('----------------$e-----------');
      state = ErrorPostState(message: e.toString());
      // Utils.flashBarErrorMessage('$e' currentContext);

      // Utils.toastMessage('$e');
    }
  }
}
