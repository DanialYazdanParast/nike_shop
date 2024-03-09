import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository repository;
  OrderHistoryBloc(this.repository) : super(OrderHistoryLoding()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStartedEvent) {
        try {
          emit(OrderHistoryLoding());
          final orders = await repository.getOrder();
          emit(OrderHistorySuccess(orders));
        } catch (e) {
          emit(OrderHistoryErroe(AppException()));
        }
      }
    });
  }
}
