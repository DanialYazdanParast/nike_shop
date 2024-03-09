import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/data/auth_info.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_shop/ui/favorites/favorites_screen.dart';
import 'package:nike_shop/ui/order/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('پروفایل'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<AuthInfo?>(
            valueListenable: AuthRepository.authChangeNotifier,
            builder: (context, autInfo, child) {
              bool isLogin = autInfo != null && autInfo!.accessToken.isNotEmpty;
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 32, bottom: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1),
                          shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/img/nike_logo.png',
                      ),
                    ),
                    Text(isLogin ? autInfo.email : 'کاربر مهمان'),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FavoritListScreen(),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 16,
                            ),
                            Text('لیست علاقه مندی ها')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen(),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 16,
                            ),
                            Text('سوابق سفارش')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          showDialog(
                            context: context,
                            useRootNavigator: true,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text('خروج از حساب کاربری'),
                                  content: const Text(
                                      'آیا میخواهید از حساب کاربری خود خارج شوید'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('خیر')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          authRepository.signOut();
                                          CartRepository
                                              .cartItemCountNotifier.value = 0;
                                        },
                                        child: const Text('بله'))
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => AuthScreen(),
                          ));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: Row(
                          children: [
                            Icon(isLogin
                                ? CupertinoIcons.arrow_right_square
                                : CupertinoIcons.arrow_left_square),
                            SizedBox(
                              width: 16,
                            ),
                            Text(isLogin
                                ? 'خروج از حساب کاربری'
                                : 'ورود به حساب کاربری'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              );
            }));
  }
}




// import 'package:flutter/material.dart';
// import 'package:nike_shop/data/auth_info.dart';
// import 'package:nike_shop/data/repo/auth_repository.dart';
// import 'package:nike_shop/data/repo/cart_repository.dart';
// import 'package:nike_shop/ui/auth/auth.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

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
//                             CartRepository.cartItemCountNotifier.value = 0;
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
