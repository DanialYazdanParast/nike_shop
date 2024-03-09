import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository repository;

  ProductListBloc(this.repository) : super(ProductListLoding()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoding());
        try {
          final product = await repository.getAll(event.sort);
          emit(ProductListSuccess(product, event.sort, ProductSort.names));
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
