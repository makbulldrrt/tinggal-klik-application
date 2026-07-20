import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../app/data/services/api_service.dart';

class SupportService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Response> postUlasan(int bookingId, int lapangId, int rating, String ulasan) {
    return _dio.post('/customer/ulasan', data: {
      'booking_id': bookingId,
      'lapang_id': lapangId,
      'rating': rating,
      'ulasan': ulasan,
    });
  }

  Future<Response> requestWithdrawal(double amount, String bankName, String accNumber) {
    return _dio.post('/owner/withdrawal/request', data: {
      'amount': amount,
      'bank_name': bankName,
      'account_number': accNumber,
    });
  }
}
