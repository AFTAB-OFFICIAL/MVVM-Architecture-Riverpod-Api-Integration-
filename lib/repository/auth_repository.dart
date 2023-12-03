import 'package:riverpod_api_integration/data/network/base_api_services.dart';
import 'package:riverpod_api_integration/data/network/network_api_services.dart';
import 'package:riverpod_api_integration/res/app_urls.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<dynamic> loginApi(data) async {
    try {
      var response =
          await _apiServices.getPostApiResponse(AppUrls.loginApiUrl, data);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> registerUser(data) async {
    try {
      var response =
          _apiServices.getPostApiResponse(AppUrls.registerApiUrl, data);
    } catch (e) {
      throw e;
    }
  }
}
