import 'package:dio/dio.dart';

import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/common/response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidat
    implements IBannerDataSource {
  final Dio httpClient;
  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validatResponse(response);
    final List<BannerEntity> banners = [];
    (response.data as List).forEach((jsonObject) {
      banners.add(BannerEntity.fromJson(jsonObject));
    });
    return banners;
  }
}
