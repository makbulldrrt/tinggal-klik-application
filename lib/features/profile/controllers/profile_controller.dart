import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController with StateMixin<Map<String, dynamic>> {
  final ProfileService _service = ProfileService();
  final formStatus = Rx<RxStatus>(RxStatus.empty());

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.getProfile();
      change(res.data as Map<String, dynamic>, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memuat profil.',
      ));
    }
  }

  Future<void> updateProfile(String name, String email, String phone) async {
    formStatus.value = RxStatus.loading();
    try {
      final res = await _service.updateProfile({
        'name': name,
        'email': email,
        'phone': phone,
      });
      change(res.data as Map<String, dynamic>, status: RxStatus.success());
      formStatus.value = RxStatus.success();
      Get.snackbar('Sukses', 'Profil berhasil diperbarui');
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memperbarui profil.',
      );
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }
}
