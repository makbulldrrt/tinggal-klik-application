import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../services/lapangan_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../dashboard/controllers/owner_dashboard_controller.dart';

class OwnerLapanganController extends GetxController with StateMixin<List<dynamic>> {
  final LapanganService _service = LapanganService();

  final RxString searchRx = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  final formStatus = Rx<RxStatus>(RxStatus.empty());
  final pickedImage = Rxn<XFile>();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image;
    }
  }

  @override
  void onInit() {
    super.onInit();
    debounce(searchRx, (_) {
      _page = 1;
      _hasMore = true;
      fetchList();
    }, time: const Duration(milliseconds: 500));

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (_hasMore && !_isLoadingMore) {
          _loadMore();
        }
      }
    });

    fetchList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _page = 1;
    _hasMore = true;
    fetchList();
  }

  String _buildQuery() {
    final category = selectedCategory.value != 'Semua' ? '&category=${selectedCategory.value}' : '';
    return '?page=$_page&search=${searchRx.value}$category';
  }

  Future<void> fetchList() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.fetchOwnerLapangan(_buildQuery());

      final responseData = res.data is Map ? res.data['data'] : res.data;
      final dataList = List<dynamic>.from(responseData as List);

      if (res.data is Map) {
        _hasMore = _page < (res.data['last_page'] ?? 1);
      } else {
        _hasMore = false;
      }

      dataList.isEmpty ? change([], status: RxStatus.empty()) : change(dataList, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memuat data.'));
    }
  }

  Future<void> _loadMore() async {
    _isLoadingMore = true;
    change(state, status: RxStatus.loadingMore());
    _page++;

    try {
      final res = await _service.fetchOwnerLapangan(_buildQuery());

      final responseData = res.data is Map ? res.data['data'] : res.data;
      final dataList = List<dynamic>.from(responseData as List);

      if (res.data is Map) {
        _hasMore = _page < (res.data['last_page'] ?? 1);
      } else {
        _hasMore = false;
      }

      final currentData = state ?? [];
      currentData.addAll(dataList);

      change(currentData, status: RxStatus.success());
    } on DioException catch (_) {
      _page--;
      change(state, status: RxStatus.success());
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    formStatus.value = RxStatus.loading();
    try {
      final formData = FormData.fromMap(data);
      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'foto',
          MultipartFile.fromBytes(
            await pickedImage.value!.readAsBytes(),
            filename: pickedImage.value!.name,
          ),
        ));
      }

      await _service.createLapangan(formData);
      formStatus.value = RxStatus.success();
      pickedImage.value = null;
      Get.back();
      _page = 1;
      fetchList();
      if (Get.isRegistered<OwnerDashboardController>()) {
        Get.find<OwnerDashboardController>().fetchDashboardData();
      }
      Get.snackbar('Sukses', 'Lapangan berhasil ditambahkan', backgroundColor: Colors.green, colorText: Colors.white);
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal menyimpan data.');
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }

  Future<void> editLapangan(int id, Map<String, dynamic> data) async {
    formStatus.value = RxStatus.loading();
    try {
      final formData = FormData.fromMap(data);
      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'foto',
          MultipartFile.fromBytes(
            await pickedImage.value!.readAsBytes(),
            filename: pickedImage.value!.name,
          ),
        ));
      }

      await _service.updateLapangan(id, formData);
      formStatus.value = RxStatus.success();
      pickedImage.value = null;
      Get.back();
      _page = 1;
      fetchList();
      if (Get.isRegistered<OwnerDashboardController>()) {
        Get.find<OwnerDashboardController>().fetchDashboardData();
      }
      Get.snackbar('Sukses', 'Lapangan berhasil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal memperbarui data.');
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }

  Future<void> deleteLapangan(int id) async {
    change(null, status: RxStatus.loading());
    try {
      await _service.deleteLapangan(id);
      _page = 1;
      fetchList();
      if (Get.isRegistered<OwnerDashboardController>()) {
        Get.find<OwnerDashboardController>().fetchDashboardData();
      }
      Get.snackbar('Sukses', 'Lapangan berhasil dihapus', backgroundColor: Colors.green, colorText: Colors.white);
    } on DioException catch (e) {
      change(state, status: RxStatus.error(e.response?.data['message']?.toString() ?? 'Gagal menghapus data.'));
      Get.snackbar('Error', e.response?.data['message']?.toString() ?? 'Gagal menghapus data.');
    }
  }
}
