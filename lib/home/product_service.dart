import 'package:dio/dio.dart';

class ProductService {
  final _dio = Dio();

  Future<List<dynamic>> fetchProducts({int limit = 10, int skip = 0}) async {
    final response = await _dio.get('https://dummyjson.com/products', queryParameters: {
      'limit': limit,
      'skip': skip,
    });

    return response.data['products'];
  }
}
