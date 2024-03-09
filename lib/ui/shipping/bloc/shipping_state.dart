part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitial extends ShippingState {}

final class ShippingLoding extends ShippingState {}

final class ShippingError extends ShippingState {
  final AppException appException;

  const ShippingError(this.appException);
  @override
  List<Object> get props => [appException];
}

final class ShippingSuccess extends ShippingState {
  final CreateOrderResult result;

  const ShippingSuccess(this.result);
  @override
  List<Object> get props => [result];
}
