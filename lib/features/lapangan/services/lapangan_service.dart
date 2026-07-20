import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class LapanganService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> fetchCustomerLapangan({Map<String, dynamic>? queryParameters}) {
    return _dio.get('/customer/lapangan', queryParameters: queryParameters);
  }

  Future<Response> fetchCustomerLapanganDetail(int id) {
    return _dio.get('/customer/lapangan/$id');
  }

  Future<Response> fetchOwnerLapangan() {
    return _dio.get('/owner/lapangan');
  }

  Future<Response> createLapangan(Map<String, dynamic> data) {
    return _dio.post('/owner/lapangan', data: data);
  }

  Future<Response> updateLapangan(int id, Map<String, dynamic> data) {
    return _dio.put('/owner/lapangan/$id', data: data);
  }

  Future<Response> deleteLapangan(int id) {
    return _dio.delete('/owner/lapangan/$id');
  }
}
