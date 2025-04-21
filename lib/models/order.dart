class Order {
  final int id;
  final String clientEmail;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.clientEmail,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return Order(
      id: json['id'] as int,
      clientEmail: json['client_email'] as String,
      status: json['status'] as String,
      totalPrice: _toDouble(json['total_price']),
      createdAt: DateTime.parse(json['created_at'] as String),
      items:
          (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final int product;
  final String productName;
  final int quantity;

  OrderItem({
    required this.id,
    required this.product,
    required this.productName,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      product: json['product'] as int,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
