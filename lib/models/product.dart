class Product {
  final String id;
  final String productName;
  final int productCode;
  final String img;
  final int qty;
  final int unitPrice;
  final int totalPrice;

  const Product({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.img,
    required this.qty,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['_id'] ?? '') as String,
      productName: (json['ProductName'] ?? '') as String,
      productCode: (json['ProductCode'] is num)
          ? (json['ProductCode'] as num).toInt()
          : 0,
      img: (json['Img'] ?? '') as String,
      qty: (json['Qty'] is num) ? (json['Qty'] as num).toInt() : 0,
      unitPrice:
          (json['UnitPrice'] is num) ? (json['UnitPrice'] as num).toInt() : 0,
      totalPrice: (json['TotalPrice'] is num)
          ? (json['TotalPrice'] as num).toInt()
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductName': productName,
      'ProductCode': productCode,
      'Img': img,
      'Qty': qty,
      'UnitPrice': unitPrice,
      'TotalPrice': totalPrice,
    };
  }
}
