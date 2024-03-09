
import 'package:get_it/get_it.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';

var locator = GetIt.instance;
Future<void> getItInit() async {

  locator
      .registerSingleton<CartBloc>(CartBloc(cartRepository));
}