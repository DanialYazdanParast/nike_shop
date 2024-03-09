import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/product/bloc/product_bloc.dart';
import 'package:nike_shop/ui/product/comment/comment_list.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scafoldlKey = GlobalKey();
  @override
  void dispose() {
    stateSubscription?.cancel();
    _scafoldlKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCArtSucces) {
                  BlocProvider.of<CartBloc>(context).add(CartStartedEvent(AuthRepository.authChangeNotifier.value));

              
              _scafoldlKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد'),
                ),
              );
            } else if (state is ProductAddToCArtError) {
              _scafoldlKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception.message),
                ),
              );
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scafoldlKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: FloatingActionButton.extended(
                        onPressed: () async{
                          BlocProvider.of<ProductBloc>(context).add(CartAddButtonClick(widget.product.id));
                     
                        },
                        label: state is ProductAddToCArtButtonLoding
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                            : Text('افزودن به سبد خرید')));
              },
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace:
                      ImageLodingService(imageUrl: widget.product.imageUrl),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.titel,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.withPriceLable,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(
                                        decoration:
                                            TextDecoration.lineThrough),
                              ),
                              Text(widget.product.price.withPriceLable),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                        style: TextStyle(height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کاربران',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text('ثبت نظر')),
                        ],
                      ),
                    ]),
                  ),
                ),
                CommentList(
                  productId: widget.product.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
