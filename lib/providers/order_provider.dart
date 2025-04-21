import 'package:flutter/material.dart';
import '../models/order.dart';
import 'package:appparcial/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final _service = OrderService();
  List<Order> _orders = [];
  bool _loading = false;
  String? _error;

  List<Order> get orders => _orders;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> loadOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _service.fetchOrders();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
