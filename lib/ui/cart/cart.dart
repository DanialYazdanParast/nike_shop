import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/di/di.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/cart/cart_items.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/shipping/shipping.dart';
import 'package:nike_shop/ui/widgets/empty_state.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  final RefreshController _refreshController = RefreshController();
  bool stateisSuccess = false;
  @override
  void initState() {
    // cartRepository.getAll().then((value) {
    //   debugPrint(value.toString());
    // }).catchError((e) {
    //   debugPrint(e.toString());
    // });
   

    super.initState();

     AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          title: const Text('سبد خرید'),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: stateisSuccess,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShippingScreen(
                        payablePrice: state.cartResponse.payablePrice,
                        shippingCost: state.cartResponse.shippingCost,
                        totalPrice: state.cartResponse.totalPrice,
                      ),
                    ));
                  }
                },
                label: const Text('پرداخت')),
          ),
        ),
        body: BlocProvider(
          create: (context) {
            final bloc = locator.get<CartBloc>();
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {
                stateisSuccess = state is CartSuccess;
              });
              

              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;

            bloc.add(CartStartedEvent(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoding) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'درحال بروز رسانی',
                    idleText: 'برای بروز رسانی پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                    completeIcon: Icon(
                      CupertinoIcons.check_mark_circled,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStartedEvent(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDelteButtonClicked(data.id));
                          },
                          onPlusButtonClicked: () {
                            cartBloc?.add(PlusCountButtonClicked(data.id));
                          },
                          onMinusButtonClicked: () {
                            if (data.count > 1) {
                              cartBloc?.add(MinusCountButtonClicked(data.id));
                            }
                          },
                        );
                      } else {
                        return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          shippingCost: state.cartResponse.shippingCost,
                          totalPrice: state.cartResponse.totalPrice,
                        );
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                return EmptyView(
                    message:
                        'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 140,
                    ));
              } else if (state is CartEmpty) {
                return EmptyView(
                    message: 'تاکنون هیچ ایتمی به سبد خرید خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    ));
              } else {
                throw Exception('current cart state is not valid');
              }
            },
          ),
        ));
  }
}


// else {
//                 throw Exception('current cart state is not valid');
//               }


//  ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context, rootNavigator: true)
//                                 .push(MaterialPageRoute(
//                               builder: (context) => const AuthScreen(),
//                             ));
//                           },
//                           child: const Text('ورود')),



//----------------------------------------------
//----------------------------------------------
//----------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:nike_shop/data/auth_info.dart';
// import 'package:nike_shop/data/repo/auth_repository.dart';
// import 'package:nike_shop/data/repo/cart_repository.dart';
// import 'package:nike_shop/ui/auth/auth.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   void initState() {
//     cartRepository.getAll().then((value) {
//       debugPrint(value.toString());
//     }).catchError((e) {
//       debugPrint(e.toString());
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: ValueListenableBuilder<AuthInfo?>(
//           valueListenable: AuthRepository.authChangeNotifier,
//           builder: (context, authState, child) {
//             bool isAuthenticated =
//                 authState != null && authState!.accessToken.isNotEmpty;
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(isAuthenticated
//                       ? 'خوش امدید'
//                       : 'لطفا وارد حساب کاربری خود شوید'),
//                   isAuthenticated
//                       ? ElevatedButton(
//                           onPressed: () {
//                             authRepository.signOut();
//                           },
//                           child: Text('خروج از حساب'))
//                       : ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context, rootNavigator: true)
//                                 .push(MaterialPageRoute(
//                               builder: (context) => AuthScreen(),
//                             ));
//                           },
//                           child: Text('ورود')),
//                   ElevatedButton(
//                       onPressed: () async {
//                         await authRepository.refreshToken();
//                       },
//                       child: Text('refresh token')),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
// }

