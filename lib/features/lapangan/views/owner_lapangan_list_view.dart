import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/owner_lapangan_controller.dart';

class OwnerLapanganListView extends GetView<OwnerLapanganController> {
  const OwnerLapanganListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/owner/lapangan/form'),
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
      ),
      body: controller.obx(
        (data) => RefreshIndicator(
          onRefresh: controller.fetchList,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: data!.length,
            itemBuilder: (_, i) => _OwnerLapanganCard(
              item: data[i],
              onEdit: () => Get.toNamed('/owner/lapangan/form', arguments: data[i]),
              onDelete: () => _confirmDelete(context, data[i]['id'] as int),
            ),
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
        onEmpty: const Center(
          child: Text('Belum ada lapangan. Tambahkan sekarang!', style: TextStyle(color: Color(0xFF94A3B8))),
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

  void _confirmDelete(BuildContext context, int id) {
    Get.defaultDialog(
      title: 'Hapus Lapangan',
      middleText: 'Yakin ingin menghapus lapangan ini?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        Get.back();
        controller.deleteLapangan(id);
      },
    );
  }
}

class _OwnerLapanganCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OwnerLapanganCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Row(
                  children: [
                    Text(item['jenis']?.toString() ?? '-', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (item['status'] == true) ? const Color(0xFF166534) : const Color(0xFF7F1D1D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (item['status'] == true) ? 'Aktif' : 'Nonaktif',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF818CF8)),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }
}
