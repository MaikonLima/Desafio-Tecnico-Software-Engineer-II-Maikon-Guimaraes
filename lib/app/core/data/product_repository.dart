import 'package:dio/dio.dart';
import 'models/product.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository([Dio? dio])
    : _dio =
          dio ??
                Dio(
                  BaseOptions(
                    baseUrl: 'https://fakestoreapi.com',
                    connectTimeout: const Duration(seconds: 12),
                    receiveTimeout: const Duration(seconds: 15),
                    sendTimeout: const Duration(seconds: 12),
                    validateStatus: (status) =>
                        status != null && status >= 200 && status < 400,
                  ),
                )
            ..interceptors.add(
              LogInterceptor(
                request: true,
                requestBody: false,
                responseBody: false,
                error: true,
              ),
            );

  Future<List<Product>> fetchAll() async {
    try {
      final res = await _dio.get('/products');
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map(Product.fromJson).toList();
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<Product> fetchById(int id) async {
    try {
      final res = await _dio.get('/products/$id');
      return Product.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
