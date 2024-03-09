import 'package:nike_shop/data/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int count;
  bool deleteButtonLoding = false;
  bool changeCountLoding = false;

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parsejsonArray(List<dynamic> jsonArry) {
    final List<CartItemEntity> cartItems = [];
    jsonArry.forEach((element) {
      cartItems.add(CartItemEntity.fromJson(element));
    });
    return cartItems;
  }
}
