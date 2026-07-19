import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/lapangan_service.dart';

class CustomerLapanganController extends GetxController
    with StateMixin<List<dynamic>> {
  final LapanganService _service = LapanganService();

  final selectedDetail = Rxn<Map<String, dynamic>>();
  final detailStatus = Rx<RxStatus>(RxStatus.empty());

  @override
  void onInit() {
    super.onInit();
    fetchList();
  }

  Future<void> fetchList() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.fetchCustomerLapangan();
      final data = List<dynamic>.from(res.data as List);
      data.isEmpty
          ? change([], status: RxStatus.empty())
          : change(data, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memuat data.'));
    }
  }

  Future<void> fetchDetail(int id) async {
    detailStatus.value = RxStatus.loading();
    selectedDetail.value = null;
    try {
      final res = await _service.fetchCustomerLapanganDetail(id);
      selectedDetail.value = Map<String, dynamic>.from(res.data as Map);
      detailStatus.value = RxStatus.success();
    } on DioException catch (e) {
      detailStatus.value = RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memuat detail.');
    }
  }
}
