import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class DashboardService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> getOwnerDashboard({String? startDate, String? endDate}) {
    if (startDate != null && endDate != null) {
      return _dio.get('/owner/dashboard?start_date=$startDate&end_date=$endDate');
    }
    return _dio.get('/owner/dashboard');
  }

  Future<Response> getAnalyticsData({String? startDate, String? endDate}) {
    if (startDate != null && endDate != null) {
      return _dio.get('/owner/dashboard/analytics?start_date=$startDate&end_date=$endDate');
    }
    return _dio.get('/owner/dashboard/analytics');
  }
}
