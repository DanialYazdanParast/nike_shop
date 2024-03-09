import 'package:dio/dio.dart';

import 'package:nike_shop/data/common/response_validator.dart';
import 'package:nike_shop/data/product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> searche(String searchTerm);
}

class ProductRemoteDataSource with HttpResponseValidat implements IProductDataSource {
  final Dio httpClient;
  ProductRemoteDataSource(this.httpClient);
  @override
  Future<List<ProductEntity>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validatResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

  @override
  Future<List<ProductEntity>> searche(String searchTerm) async{
       final response = await httpClient.get('product/search?q=$searchTerm');
    validatResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

 
}
