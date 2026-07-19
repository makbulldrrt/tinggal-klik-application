import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_lapangan_controller.dart';

class CustomerLapanganListView extends GetView<CustomerLapanganController> {
  const CustomerLapanganListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Catalog Lapangan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Get.toNamed('/customer/profile'),
          ),
        ],
      ),
      body: controller.obx(
        (data) => RefreshIndicator(
          onRefresh: controller.fetchList,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data!.length,
            itemBuilder: (_, i) => _LapanganCard(item: data[i]),
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
        onEmpty: const Center(
          child: Text('Belum ada lapangan tersedia.', style: TextStyle(color: Color(0xFF94A3B8))),
        ),
        onError: (err) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(err ?? 'Terjadi kesalahan.', style: const TextStyle(color: Color(0xFFEF4444))),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: controller.fetchList, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      ),
    );
  }
}

class _LapanganCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _LapanganCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/customer/lapangan/detail', arguments: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_soccer, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nama']?.toString() ?? '-',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['jenis']?.toString() ?? '-',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              'Rp ${item['harga_per_jam']?.toString() ?? '0'}/jam',
              style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
