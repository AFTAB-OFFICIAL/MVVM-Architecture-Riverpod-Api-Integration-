import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riverpod_api_integration/data/network/base_api_services.dart';

import 'package:riverpod_api_integration/services/app_exception.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      // SocketExpection basically no internet available
      throw FetchDataException('No Internet Available');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;

    try {
      Response response = await post(Uri.parse(url), body: data);
      // .timeout(
      //   Duration(
      //     seconds: 20,
      //   ),
      // );
      responseJson = returnResponse(response);
    } on SocketException {
      // SocketExpection basically no internet available
      throw FetchDataException('No Internet Available');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnAuthorizedExpection(response.body.toString());
      default:
        throw FetchDataException(
          'Error occured while communicating with server' +
              'with status code' +
              response.statusCode.toString(),
        );
    }
  }
}
