import 'package:hive/hive.dart';

part 'product.g.dart';

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int pricelowToHigh = 3;

  static List<String> names = [
    'جدید ترین',
    'پر بازدید ترین',
    'قیمت نزولی',
    'قیمت صعودی',
  ];
}

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String titel;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int previousPrice;

  ProductEntity(this.id, this.titel, this.imageUrl, this.price, this.discount,
      this.previousPrice);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titel = json['title'],
        imageUrl = json['image'],
        price = json['previous_price'] == null
            ? json['price'] - json['discount']
            : json['price'],
        discount = json['discount'],
        previousPrice = json['previous_price'] ?? json['price'];
}
