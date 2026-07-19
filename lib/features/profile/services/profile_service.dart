import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class ProfileService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> getProfile() {
    return _dio.get('/customer/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put('/customer/profile', data: data);
  }
}
