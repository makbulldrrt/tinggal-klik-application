import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class DashboardService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> getOwnerDashboard() {
    return _dio.get('/owner/dashboard');
  }
}
