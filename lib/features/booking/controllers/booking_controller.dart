import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/booking_service.dart';

class BookingController extends GetxController with StateMixin<List<dynamic>>, WidgetsBindingObserver {
  final BookingService _service = BookingService();

  final selectedDate = ''.obs;
  final bookedSlots = <String>[].obs;
  final selectedSlots = <String>[].obs;
  final bookingHistory = <dynamic>[].obs;
  final slotStatus = Rx<RxStatus>(RxStatus.empty());
  final formStatus = Rx<RxStatus>(RxStatus.empty());
  bool _awaitingPaymentReturn = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchHistory();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingPaymentReturn) {
      _awaitingPaymentReturn = false;
      fetchHistory();
    }
  }

  Future<void> fetchAvailability(int lapanganId, String tanggal) async {
    selectedDate.value = tanggal;
    selectedSlots.clear();
    slotStatus.value = RxStatus.loading();
    try {
      final res = await _service.getAvailability(lapanganId, tanggal);
      final booked = List<String>.from(res.data as List);
      bookedSlots.value = booked;
      slotStatus.value = RxStatus.success();
    } on DioException catch (e) {
      slotStatus.value = RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memuat slot.',
      );
    }
  }

  void toggleSlot(String jam) {
    if (selectedSlots.contains(jam)) {
      selectedSlots.remove(jam);
    } else {
      selectedSlots.add(jam);
    }
  }

  Future<void> checkout(int lapanganId, int hargaPerJam) async {
    if (selectedDate.value.isEmpty || selectedSlots.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih tanggal dan minimal satu jam terlebih dahulu.');
      return;
    }
    formStatus.value = RxStatus.loading();
    try {
      final sortedSlots = selectedSlots.toList()..sort();
      final jamMulai = sortedSlots.first;
      final durasi = sortedSlots.length;
      final totalHarga = durasi * hargaPerJam;

      final res = await _service.createBooking({
        'lapangan_id': lapanganId,
        'tanggal_main': selectedDate.value,
        'jam_mulai': jamMulai,
        'durasi': durasi,
        'total_harga': totalHarga,
      });

      final snapUrl = res.data['snap_url']?.toString();
      formStatus.value = RxStatus.success();
      selectedSlots.clear();

      if (snapUrl != null && snapUrl.isNotEmpty) {
        _awaitingPaymentReturn = true;
        final uri = Uri.parse(snapUrl);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Get.back();
      } else {
        Get.snackbar('Booking Berhasil', 'Menunggu pembayaran dikonfirmasi.');
        fetchHistory();
      }
    } on DioException catch (e) {
      formStatus.value = RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal membuat booking.',
      );
      Get.snackbar('Error', formStatus.value.errorMessage ?? '');
    }
  }

  Future<void> fetchHistory() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _service.getBookingHistory();
      final data = List<dynamic>.from(res.data as List);
      data.isEmpty
          ? change([], status: RxStatus.empty())
          : change(data, status: RxStatus.success());
    } on DioException catch (e) {
      change(null, status: RxStatus.error(
        e.response?.data['message']?.toString() ?? 'Gagal memuat riwayat.',
      ));
    }
  }
}
