import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/lapangan_service.dart';

class CustomerLapanganController extends GetxController with StateMixin<List<dynamic>> {
  final LapanganService _service = LapanganService();

  final RxString searchRx = ''.obs;
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  final selectedDetail = Rxn<Map<String, dynamic>>();
  final detailStatus = Rx<RxStatus>(RxStatus.empty());

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

  Future<void> fetchList() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.fetchCustomerLapangan(
        queryParameters: {
          'search': searchRx.value,
          'page': _page,
        },
      );
      
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
      final res = await _service.fetchCustomerLapangan(
        queryParameters: {
          'search': searchRx.value,
          'page': _page,
        },
      );
      
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
