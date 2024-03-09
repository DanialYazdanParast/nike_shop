import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLable on int {
  String get withPriceLable => this > 0 ? '$separateByComa تومان' : 'رایگان';

  String get separateByComa {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
