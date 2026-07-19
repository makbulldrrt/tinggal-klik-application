import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class BookingService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> getAvailability(int lapanganId, String tanggal) {
    return _dio.get(
      '/customer/lapangan/$lapanganId/availability',
      queryParameters: {'tanggal': tanggal},
    );
  }

  Future<Response> createBooking(Map<String, dynamic> data) {
    return _dio.post('/customer/bookings', data: data);
  }

  Future<Response> getBookingHistory() {
    return _dio.get('/customer/bookings/history');
  }
}
