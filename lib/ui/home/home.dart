
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/banner_repository.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/home/bloc/home_bloc.dart';
import 'package:nike_shop/ui/list/list.dart';
import 'package:nike_shop/ui/product/produc.dart';
import 'package:nike_shop/ui/widgets/error.dart';

import 'package:nike_shop/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homebloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homebloc.add(HomeStartedEvent());
        return homebloc;
      },
      child: Scaffold(body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccesState) {
              return ListView.builder(
                physics: defaultScrollPhysics,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Container(
                        height: 56,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/img/nike_logo.png',
                          height: 24,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    case 2:
                      return BannerSlider(
                        banners: state.banners,
                      );
                    case 3:
                      return _HorizontalProductList(
                        titel: 'جدید ترین',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProductListScreen(
                                sort: ProductSort.latest),
                          ));
                        },
                        products: state.latestProduct,
                      );

                    case 4:
                      return _HorizontalProductList(
                        titel: 'پر بازدید ترین',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProductListScreen(
                                sort: ProductSort.popular),
                          ));
                        },
                        products: state.popularProduct,
                      );
                    default:
                      return Container();
                  }
                },
              );
            } else if (state is HomeLodingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeErrorState) {
              return AppErrorWidget(
                exception: state.exception,
                onpressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent());
                },
              );
            } else {
              throw Exception('state is not supported ');
            }
          },
        ),
      )),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String titel;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;

  const _HorizontalProductList({
    super.key,
    required this.titel,
    required this.onTap,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titel,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(
                onPressed: onTap,
                child: const Text(' مشاهده همه'),
              )
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            physics: defaultScrollPhysics,
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 8, right: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                product: product,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
        )
      ],
    );
  }
}
