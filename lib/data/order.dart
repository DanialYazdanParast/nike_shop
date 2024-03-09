import 'package:nike_shop/data/product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult(this.orderId, this.bankGatewayUrl);

  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String adress;
  final PaymentMethod paymentMethod;

  CreateOrderParams(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.postalCode,
      required this.adress,
      required this.paymentMethod});
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntitty {
  final int id;
  final int paypleprice;
  final List<ProductEntity> items;

  const OrderEntitty(this.id, this.paypleprice, this.items);

  OrderEntitty.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        paypleprice = json['payable'],
        items = (json['order_items'] as List)
            .map((item) => ProductEntity.fromJson(item['product']))
            .toList();
}
