import 'package:nike_shop/data/cart_item.dart';

class CartResponse {
  List<CartItemEntity> cartItems;
  int payablePrice;
  int totalPrice;
  int shippingCost;

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItems = CartItemEntity.parsejsonArray(json['cart_items']),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shippingCost = json['shipping_cost'];
}
