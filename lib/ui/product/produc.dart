import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/data/source/favorite_manager.dart';
import 'package:nike_shop/di/di.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/product/details.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemheight = 189,
  });

  final ProductEntity product;
  final BorderRadius borderRadius;
  final double itemWidth;
  final double itemheight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<CartBloc>.value(
                value: locator.get<CartBloc>(),
                child: ProductDetailsScreen(product: widget.product),
              ),
            ),
          ),
          child: SizedBox(
            width: widget.itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLodingService(
                        imageUrl: widget.product.imageUrl,
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          if (!favoriteManager.isFavorite(widget.product)) {
                            favoriteManager.addFavorite(widget.product);
                          } else {
                            favoriteManager.delete(widget.product);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            favoriteManager.isFavorite(widget.product)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.titel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    widget.product.previousPrice.withPriceLable,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 4),
                  child: Text(widget.product.price.withPriceLable),
                ),
              ],
            ),
          ),
        ));
  }
}
