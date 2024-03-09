part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListStarted extends ProductListEvent {
  final int sort;

  const ProductListStarted(this.sort);
  @override
  // TODO: implement props
  List<Object> get props => [sort];
}
