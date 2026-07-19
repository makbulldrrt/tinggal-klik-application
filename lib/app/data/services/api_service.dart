import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  final Dio dio;
  final GetStorage _box = GetStorage();

  ApiService()
      : dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _box.read<String>('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
