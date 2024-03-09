
import 'package:flutter/material.dart';
import 'package:nike_shop/common/exceptions.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onpressed;
  const AppErrorWidget({
    super.key,
    required this.exception, required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(exception.message),
          ElevatedButton(
              onPressed: onpressed,
              child: const Text('تلاش دوباره'))
        ],
      ),
    );
  }
}