import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        try {
          emit(ProductAddToCArtButtonLoding());
          //  await Future.delayed(Duration(seconds: 2));
          final result = await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCArtSucces());
        } catch (e) {
          emit(ProductAddToCArtError(AppException()));
        }
      }
    });
  }
}
