import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/lapangan_service.dart';

class OwnerLapanganController extends GetxController
    with StateMixin<List<dynamic>> {
  final LapanganService _service = LapanganService();

  final formStatus = Rx<RxStatus>(RxStatus.empty());

  @override
  void onInit() {
    super.onInit();
    fetchList();
  }

  Future<void> fetchList() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.fetchOwnerLapangan();
      final data = List<dynamic>.from(res.data as List);
      data.isEmpty
          ? change([], status: RxStatus.empty())
          : change(data, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memuat data.'));
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    formStatus.value = RxStatus.loading();
    try {
      await _service.createLapangan(data);
      formStatus.value = RxStatus.success();
      Get.back();
      fetchList();
      Get.snackbar('Berhasil', 'Lapangan berhasil ditambahkan.');
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal menyimpan data.');
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }

  Future<void> editLapangan(int id, Map<String, dynamic> data) async {
    formStatus.value = RxStatus.loading();
    try {
      await _service.updateLapangan(id, data);
      formStatus.value = RxStatus.success();
      Get.back();
      fetchList();
      Get.snackbar('Berhasil', 'Lapangan berhasil diperbarui.');
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memperbarui data.');
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }

  Future<void> deleteLapangan(int id) async {
    change(null, status: RxStatus.loading());
    try {
      await _service.deleteLapangan(id);
      fetchList();
      Get.snackbar('Berhasil', 'Lapangan berhasil dihapus.');
    } on DioException catch (e) {
      change(state, status: RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal menghapus data.'));
      Get.snackbar('Error', e.response?.data['message']?.toString() ?? 'Gagal menghapus data.');
    }
  }
}
