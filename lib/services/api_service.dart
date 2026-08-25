import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String baseUrl =
      'https://crud-api-ostad-live.onrender.com/api/v1';
  static const Duration _timeout = Duration(seconds: 30);

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<List<Product>> readProducts() async {
    final response =
        await http.get(_uri('/ReadProduct')).timeout(_timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'];
      if (data is List) {
        return data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }
    throw Exception('Failed to load products (${response.statusCode})');
  }

  Future<Product> createProduct(Product product) async {
    final response = await http
        .post(
          _uri('/CreateProduct'),
          headers: _headers,
          body: jsonEncode(product.toJson()),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'];
      if (data is Map<String, dynamic>) {
        return Product.fromJson(data);
      }
      return product;
    }
    throw Exception('Failed to create product (${response.statusCode})');
  }

  Future<void> updateProduct(String id, Product product) async {
    final response = await http
        .post(
          _uri('/UpdateProduct/$id'),
          headers: _headers,
          body: jsonEncode(product.toJson()),
        )
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Failed to update product (${response.statusCode})');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http
        .get(_uri('/DeleteProduct/$id'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product (${response.statusCode})');
    }
  }
}
