import 'package:adopt_app/models/user.dart';
import 'package:dio/dio.dart';

class AuthServices {
  final Dio _dio = Dio();

  final _baseUrl = 'https://coded-pets-api-auth.eapi.joincoded.com';

  Future<String> signup({required User user}) async {
    late String token;
    try {
      Response response =
          await _dio.post(_baseUrl + '/signup', data: user.toJson());
      token = response.data["token"];
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }
}
