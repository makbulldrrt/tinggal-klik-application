import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_lapangan_controller.dart';

class CustomerLapanganDetailView extends GetView<CustomerLapanganController> {
  const CustomerLapanganDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final id = args?['id'];

    if (id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchDetail(id as int);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          args?['nama']?.toString() ?? 'Detail Lapangan',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final status = controller.detailStatus.value;
        final detail = controller.selectedDetail.value;

        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
        }
        if (status.isError) {
          return Center(
            child: Text(status.errorMessage ?? 'Terjadi kesalahan.', style: const TextStyle(color: Color(0xFFEF4444))),
          );
        }
        if (detail == null) {
          return const Center(
            child: Text('Data tidak tersedia.', style: TextStyle(color: Color(0xFF94A3B8))),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.sports_soccer, color: Colors.white, size: 64),
              ),
              const SizedBox(height: 24),
              _DetailRow(label: 'Nama', value: detail['nama']?.toString()),
              _DetailRow(label: 'Jenis', value: detail['jenis']?.toString()),
              _DetailRow(label: 'Harga/Jam', value: 'Rp ${detail['harga_per_jam']?.toString()}'),
              _DetailRow(label: 'Status', value: (detail['status'] == true) ? 'Tersedia' : 'Tidak Tersedia'),
              _DetailRow(label: 'Deskripsi', value: detail['deskripsi']?.toString()),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  const _DetailRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value ?? '-', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          const Divider(color: Color(0xFF334155), height: 24),
        ],
      ),
    );
  }
}
