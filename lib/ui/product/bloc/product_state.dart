part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddToCArtButtonLoding extends ProductState {}

class ProductAddToCArtError extends ProductState {
  final AppException exception;

  const ProductAddToCArtError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

class ProductAddToCArtSucces extends ProductState {}
