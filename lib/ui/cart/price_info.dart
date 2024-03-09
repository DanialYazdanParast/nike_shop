import 'package:flutter/material.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/theme.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.totalPrice,
      required this.shippingCost});
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            'جزئیات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1))
              ]),
          child: Column(children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('مبلغ کل خرید '),
                  RichText(
                    text: TextSpan(
                      text: totalPrice.separateByComa,
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(color: LightThemeColors.secondaryColor),
                      children: const [
                        TextSpan(
                          text: ' تومان',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(' هزینه ارسال '),
                  Text(shippingCost.withPriceLable),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, top: 12, right: 8, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(' مبلغ قابل پرداخت'),
                  RichText(
                    text: TextSpan(
                      text: payablePrice.separateByComa,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      children: const [
                        TextSpan(
                            text: ' تومان',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
