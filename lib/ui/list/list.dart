import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_shop/ui/product/produc.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({super.key, required this.sort});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { graid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.graid;
  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
        centerTitle: true,
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.product;
              return Column(
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(32))),
                          builder: (context) {
                            return Container(
                              height: 400,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 24),
                                child: Column(children: [
                                  Text(
                                    'انتخاب مرتب سازی',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.sortName.length,
                                      itemBuilder: (context, index) {
                                        final selectedSortIndex = state.sort;
                                        return InkWell(
                                          onTap: () {
                                            bloc!
                                                .add(ProductListStarted(index));

                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: SizedBox(
                                              height: 32,
                                              child: Row(
                                                children: [
                                                  Text(state.sortName[index]),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  if (index ==
                                                      selectedSortIndex)
                                                    Icon(
                                                      CupertinoIcons
                                                          .check_mark_circled_solid,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ]),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.sort_down)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('مرتب سازی'),
                                    Text(
                                      ProductSort.names[state.sort],
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.graid
                                      ? ViewType.list
                                      : ViewType.graid;
                                });
                              },
                              icon: const Icon(CupertinoIcons.square_grid_2x2)),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.65,
                        crossAxisCount: viewType == ViewType.graid ? 2 : 1,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
