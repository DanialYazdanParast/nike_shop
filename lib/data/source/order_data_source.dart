import 'package:dio/dio.dart';
import 'package:nike_shop/data/common/response_validator.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceiptData(int orderId);
  Future<List<OrderEntitty>> getOrder();
}

class OrderRemoteDataSource
    with HttpResponseValidat
    implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.lastName,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.phoneNumber,
      'address': params.adress,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? "online"
          : "cash_on_delivery",
    });
    validatResponse(response);

    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceiptData(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    validatResponse(response);

    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntitty>> getOrder() async {
    final response = await httpClient.get('order/list');
    return (response.data as List)
        .map((item) => OrderEntitty.fromJson(item))
        .toList();
  }
}
