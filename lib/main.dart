import 'package:flutter/material.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/banner_repository.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/data/source/favorite_manager.dart';
import 'package:nike_shop/di/di.dart';
import 'package:nike_shop/theme.dart';

import 'package:nike_shop/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
    await getItInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    productRepository.getAll(ProductSort.latest).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });

    bannerRepository.getAll().then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    const defaultTextStyle = TextStyle(
        fontFamily: 'Shabnam', color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      ///////////////////////////////
      theme: ThemeData(
        hintColor: LightThemeColors.secondaryTextColor,
        //-----------------------------------
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: LightThemeColors.primaryTextColor.withOpacity(0.1),
            ),
          ),
        ),

        //-----------------------------------
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColors.primaryTextColor),
        //-----------------------------------
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: defaultTextStyle.apply(color: Colors.white),
        ),
        //-----------------------------------
        textTheme: TextTheme(
          subtitle1: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
          button: defaultTextStyle,
          bodyText2: defaultTextStyle,
          caption: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
          headline6: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
        //-----------------------------------
        colorScheme: const ColorScheme.light(
          primary: LightThemeColors.primaryColor,
          secondary: LightThemeColors.secondaryColor,
          onSecondary: Colors.white,
          surfaceVariant: Color(0xfff5f5f5),
        ),
        //-----------------------------------
        //  useMaterial3: true,
      ),
      ////////////////////////////////////
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
