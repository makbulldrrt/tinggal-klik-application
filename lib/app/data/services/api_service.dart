import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String _apiUrl = 'http://127.0.0.1:8000/api';
  static const String storageUrl = 'http://127.0.0.1:8000/storage/';

  final Dio dio;
  final GetStorage _box = GetStorage();

  ApiService()
    : dio = Dio(
        BaseOptions(
          baseUrl: _apiUrl,
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
