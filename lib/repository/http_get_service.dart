import 'package:http/http.dart' as http;
import 'package:riverpod_api_integration/data/network/base_api_services.dart';
import 'package:riverpod_api_integration/data/network/network_api_services.dart';
import 'package:riverpod_api_integration/models/post_model.dart';
import 'package:riverpod_api_integration/res/app_urls.dart';

class HttpGetServices {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<Post>> getPost() async {
    // var jsonResponse;
    List<Post> postList = [];
    try {
      var response = await _apiServices
          .getGetApiResponse(AppUrls.baseUrl + AppUrls.postUrl);
      for (var element in response) {
        Post post = Post.fromJson(element);
        postList.add(post);
      }

      // var response = await http.get(Uri.parse(AppUrls.baseUrl + AppUrls.postUrl));
      // if (response.statusCode == 200) {
      //   jsonResponse = jsonDecode(response.body);

      //   for (var element in jsonResponse) {
      //     Post post = Post.fromJson(element);
      //     postList.add(post);
      //   }
      // }
      return postList;
    } catch (e) {
      throw e;
    }
  }
}
