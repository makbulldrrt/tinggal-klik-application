import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../../../app/data/services/api_service.dart';

class LapanganService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> fetchCustomerLapangan({Map<String, dynamic>? queryParameters}) {
    return _dio.get('/customer/lapangan', queryParameters: queryParameters);
  }

  Future<Response> fetchCustomerLapanganDetail(int id) {
    return _dio.get('/customer/lapangan/$id');
  }

  Future<Response> fetchOwnerLapangan([String query = '']) {
    return _dio.get('/owner/lapangan$query');
  }

  Future<Response> createLapangan(dynamic data) {
    return _dio.post('/owner/lapangan', data: data);
  }

  Future<Response> updateLapangan(int id, dynamic data) {
    // If we're uploading files via FormData, some backends (like Laravel)
    // require POST method with _method spoofing for multipart/form-data.
    if (data is FormData) {
      data.fields.add(const MapEntry('_method', 'PUT'));
      return _dio.post('/owner/lapangan/$id', data: data);
    }
    return _dio.put('/owner/lapangan/$id', data: data);
  }

  Future<Response> deleteLapangan(int id) {
    return _dio.delete('/owner/lapangan/$id');
  }
}
