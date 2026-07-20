import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/support_service.dart';

class SupportController extends GetxController {
  final SupportService _service = SupportService();
  
  final ulasanStatus = Rx<RxStatus>(RxStatus.empty());
  final withdrawalStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> submitUlasan(int bookingId, int lapangId, int rating, String ulasan) async {
    ulasanStatus.value = RxStatus.loading();
    try {
      await _service.postUlasan(bookingId, lapangId, rating, ulasan);
      Get.back(closeOverlays: true);
      ulasanStatus.value = RxStatus.success();
      Get.snackbar('Sukses', 'Ulasan berhasil disimpan');
    } on DioException catch (e) {
      ulasanStatus.value = RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal mengirim ulasan.',
      );
      Get.snackbar('Error', ulasanStatus.value.errorMessage ?? '');
    }
  }

  Future<void> submitWithdrawal(double amount, String bankName, String accNumber) async {
    withdrawalStatus.value = RxStatus.loading();
    try {
      await _service.requestWithdrawal(amount, bankName, accNumber);
      withdrawalStatus.value = RxStatus.success();
      Get.snackbar('Sukses', 'Permintaan penarikan berhasil dikirim.');
    } on DioException catch (e) {
      withdrawalStatus.value = RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal meminta penarikan.',
      );
      Get.snackbar('Error', withdrawalStatus.value.errorMessage ?? '');
    }
  }
}
