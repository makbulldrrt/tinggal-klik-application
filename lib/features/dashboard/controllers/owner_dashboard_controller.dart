import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/dashboard_service.dart';

class OwnerDashboardController extends GetxController with StateMixin<Map<String, dynamic>> {
  final DashboardService _service = DashboardService();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData({String? start, String? end}) async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.getOwnerDashboard(startDate: start, endDate: end);
      final analyticsRes = await _service.getAnalyticsData(startDate: start, endDate: end);
      
      final data = res.data as Map<String, dynamic>;
      data['analytics'] = analyticsRes.data;
      
      change(data, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memuat dashboard.',
      ));
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    startDate.value = start;
    endDate.value = end;
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedStart = formatter.format(start);
    final formattedEnd = formatter.format(end);
    await fetchDashboardData(start: formattedStart, end: formattedEnd);
  }

  Future<void> resetFilter() async {
    startDate.value = null;
    endDate.value = null;
    await fetchDashboardData();
  }
}
