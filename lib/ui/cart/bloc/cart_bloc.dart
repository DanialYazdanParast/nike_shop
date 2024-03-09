import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/auth_info.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoding()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStartedEvent) {
        final authInfo = event.authInfo;
        

        if (authInfo == null || authInfo.accessToken.isEmpty ) {
          emit(CartAuthRequired());
        } else {
          await lodCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartDelteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId);
            cartItem.deleteButtonLoding = true;
            emit(CartSuccess(successState.cartResponse));
          }

          // await Future.delayed(Duration(seconds: 10));

          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await lodCartItems(emit, false);
          }
        }
      } else if (event is PlusCountButtonClicked ||
          event is MinusCountButtonClicked) {
        try {
          int cartItemId = 0;
          if (event is PlusCountButtonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is MinusCountButtonClicked) {
            cartItemId = event.cartItemId;
          }
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemId);
            cartItem.changeCountLoding = true;
            emit(CartSuccess(successState.cartResponse));

            //     await Future.delayed(Duration(seconds: 2));
            final newCount = event is PlusCountButtonClicked
                ? ++cartItem.count
                : --cartItem.count;

            await cartRepository.changeCount(cartItemId, newCount);
            await cartRepository.count();

            successState.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemId)
              ..count = newCount
              ..changeCountLoding = false;

            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<void> lodCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoding());
      }

      final result = await cartRepository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }

    shippingCost = payablePrice >= 250000 ? 0 : 30000;

    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
