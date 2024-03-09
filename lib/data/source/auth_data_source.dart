import 'package:dio/dio.dart';
import 'package:nike_shop/data/auth_info.dart';
import 'package:nike_shop/data/common/constants.dart';
import 'package:nike_shop/data/common/response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> singUp(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource with HttpResponseValidat implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post('auth/token', data: {
      "grant_type": "password",
      "client_id": 2,
      "client_secret": Constants.clientsecret,
      "username": username,
      "password": password
    });
    validatResponse(response);
    return AuthInfo(response.data["access_token"],
        response.data["refresh_token"], username);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post('auth/token', data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": 2,
      "client_secret": Constants.clientsecret,
    });
    validatResponse(response);
    return AuthInfo(
        response.data["access_token"], response.data["refresh_token"], '');
  }

  @override
  Future<AuthInfo> singUp(String username, String password) async {
    final response = await httpClient
        .post('user/register', data: {"email": username, "password": password});
    validatResponse(response);
    return login(username, password);
  }
}
