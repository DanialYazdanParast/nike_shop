part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStartedEvent extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStartedEvent(this.authInfo, {this.isRefreshing = false});
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartDelteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDelteButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}

class PlusCountButtonClicked extends CartEvent {
  final int cartItemId;

  const PlusCountButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}

class MinusCountButtonClicked extends CartEvent {
  final int cartItemId;

  const MinusCountButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}
