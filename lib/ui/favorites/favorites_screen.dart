import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/source/favorite_manager.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/product/details.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class FavoritListScreen extends StatelessWidget {
  const FavoritListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManager.listenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return ListView.builder(
              itemCount: products.length,
              padding: EdgeInsets.only(top: 8, bottom: 100),
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  onLongPress: () {
                    favoriteManager.delete(product);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: ImageLodingService(
                            imageUrl: product.imageUrl,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.titel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .apply(
                                          color: LightThemeColors
                                              .primaryTextColor),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  product.previousPrice.withPriceLable,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(product.price.withPriceLable),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
