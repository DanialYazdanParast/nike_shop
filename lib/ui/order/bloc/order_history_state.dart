part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoding extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntitty> orders;

  const OrderHistorySuccess(this.orders);
  @override
  // TODO: implement props
  List<Object> get props => [orders];
}

class OrderHistoryErroe extends OrderHistoryState {
  final AppException exception;

  const OrderHistoryErroe(this.exception);

  @override
  List<Object> get props => [exception];
}
