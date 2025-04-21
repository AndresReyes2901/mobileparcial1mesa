// lib/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _api = ApiService();

  Future<List<Order>> fetchOrders() async {
    final res = await _api.get('/api/orders/');
    if (res.statusCode == 200) {
      final body = utf8.decode(res.bodyBytes);
      final List<dynamic> data = jsonDecode(body);
      return data.map((dynamic json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las órdenes');
    }
  }
}