import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/payment_webview.dart';
import 'package:nike_shop/ui/receipt/payment_receipt.dart';
import 'package:nike_shop/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.totalPrice,
      required this.shippingCost});

  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'دانیال');

  final TextEditingController lastNameController =
      TextEditingController(text: 'یزدان پرست');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09174016011');

  final TextEditingController postalCodeController =
      TextEditingController(text: '1234567899');

  final TextEditingController adressController =
      TextEditingController(text: 'بوشهر _ برازجان _ خیابان اسدی');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(event.appException.message),
                ),
              );
            } else if (event is ShippingSuccess) {
              if (event.result.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentGatewayScreen(
                          bankGatewayUrl: event.result.bankGatewayUrl),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentReceiptScreen(orderId: event.result.orderId),
                    ));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    label: Text('نام '),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    label: Text('نام خانوادگی'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    label: Text('شماره تماس'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(
                    label: Text(' کد پستی '),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: adressController,
                  decoration: const InputDecoration(
                    label: Text('آدرس'),
                  ),
                ),
                PriceInfo(
                  payablePrice: widget.payablePrice,
                  totalPrice: widget.totalPrice,
                  shippingCost: widget.shippingCost,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoding
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          postalCode: postalCodeController.text,
                                          adress: adressController.text,
                                          paymentMethod:
                                              PaymentMethod.cashOnDelivery)));

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => const PaymentReceiptScreen(),
                                  // ));
                                },
                                child: const Text(' پرداخت در محل'),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(
                                      CreateOrderParams(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          postalCode: postalCodeController.text,
                                          adress: adressController.text,
                                          paymentMethod: PaymentMethod.online),
                                    ),
                                  );
                                },
                                child: const Text('پرداخت اینترنتی'),
                              ),
                            ],
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
