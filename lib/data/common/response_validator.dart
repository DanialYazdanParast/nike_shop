import 'package:dio/dio.dart';
import 'package:nike_shop/common/exceptions.dart';

mixin HttpResponseValidat {
  validatResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
