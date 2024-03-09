import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment_receipt.dart';
import 'package:nike_shop/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) {
    return dataSource.create(params);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceiptData(int orderId) {
    return dataSource.getPaymentReceiptData(orderId);
  }

  @override
  Future<List<OrderEntitty>> getOrder() {
    return dataSource.getOrder();
  }
}
