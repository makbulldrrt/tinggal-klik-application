import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';

class LapanganBookingView extends GetView<BookingController> {
  const LapanganBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final int lapanganId = args['id'] as int? ?? 0;
    final String namaLapangan = args['nama']?.toString() ?? 'Lapangan';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(namaLapangan, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _DatePickerSection(lapanganId: lapanganId),
          const SizedBox(height: 8),
          Expanded(child: _SlotGrid(lapanganId: lapanganId)),
          _CheckoutBar(lapanganId: lapanganId, hargaPerJam: int.tryParse(args['harga_per_jam']?.toString() ?? '0') ?? 0),
        ],
      ),
    );
  }
}

class _DatePickerSection extends GetView<BookingController> {
  final int lapanganId;
  const _DatePickerSection({required this.lapanganId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E293B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Tanggal', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 8),
          Obx(
            () => InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (ctx, child) => Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(primary: Color(0xFF6366F1)),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  final formatted =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  controller.fetchAvailability(lapanganId, formatted);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF6366F1), size: 18),
                    const SizedBox(width: 12),
                    Text(
                      controller.selectedDate.value.isEmpty
                          ? 'Ketuk untuk memilih tanggal'
                          : controller.selectedDate.value,
                      style: TextStyle(
                        color: controller.selectedDate.value.isEmpty
                            ? const Color(0xFF64748B)
                            : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotGrid extends GetView<BookingController> {
  final int lapanganId;

  static const List<String> _slots = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
    '14:00', '15:00', '16:00', '17:00', '18:00', '19:00',
    '20:00', '21:00', '22:00',
  ];

  const _SlotGrid({required this.lapanganId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.slotStatus.value;

      if (controller.selectedDate.value.isEmpty) {
        return const Center(
          child: Text('Pilih tanggal untuk melihat slot tersedia.',
              style: TextStyle(color: Color(0xFF64748B))),
        );
      }

      if (status.isLoading) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
      }

      if (status.isError) {
        return Center(
          child: Text(status.errorMessage ?? 'Error',
              style: const TextStyle(color: Color(0xFFEF4444))),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
        ),
        itemCount: _slots.length,
        itemBuilder: (_, i) {
          final jam = _slots[i];
          final isBooked = controller.availableSlots.contains(jam);
          final isSelected = controller.selectedSlots.contains(jam);

          Color bgColor;
          Color textColor;
          Color borderColor;

          if (isBooked) {
            bgColor = const Color(0xFF1E293B);
            textColor = const Color(0xFF475569);
            borderColor = const Color(0xFF1E293B);
          } else if (isSelected) {
            bgColor = const Color(0xFF6366F1);
            textColor = Colors.white;
            borderColor = const Color(0xFF6366F1);
          } else {
            bgColor = const Color(0xFF1E293B);
            textColor = Colors.white;
            borderColor = const Color(0xFF334155);
          }

          return GestureDetector(
            onTap: isBooked ? null : () => controller.toggleSlot(jam),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(jam,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  if (isBooked)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                        ),
                        child: const Icon(Icons.block, color: Color(0xFF475569), size: 16),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class _CheckoutBar extends GetView<BookingController> {
  final int lapanganId;
  final int hargaPerJam;
  const _CheckoutBar({required this.lapanganId, required this.hargaPerJam});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.formStatus.value.isLoading;
      final count = controller.selectedSlots.length;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          border: Border(top: BorderSide(color: Color(0xFF334155))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count jam dipilih',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: (isLoading || count == 0) ? null : () => controller.checkout(lapanganId, hargaPerJam),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  disabledBackgroundColor: const Color(0xFF3730A3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('Bayar Sekarang',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    });
  }
}
