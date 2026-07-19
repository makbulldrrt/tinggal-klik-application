import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/dashboard_service.dart';

class OwnerDashboardController extends GetxController with StateMixin<Map<String, dynamic>> {
  final DashboardService _service = DashboardService();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.getOwnerDashboard();
      change(res.data as Map<String, dynamic>, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memuat dashboard.',
      ));
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
