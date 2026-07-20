import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/owner_lapangan_controller.dart';
import '../../../app/data/services/api_service.dart';

const _kCategories = ['Semua', 'Futsal', 'Badminton', 'Tenis', 'Basket'];

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              onChanged: (val) => controller.searchRx.value = val,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari nama lapangan...',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => _CategoryFilterBar(
            categories: _kCategories,
            selected: controller.selectedCategory.value,
            onSelect: controller.selectCategory,
            accentColor: const Color(0xFF6366F1),
          )),
          const SizedBox(height: 8),
          Expanded(
            child: controller.obx(
              (data) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: RefreshIndicator(
                  key: ValueKey(controller.selectedCategory.value),
                  onRefresh: controller.fetchList,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                    itemCount: data!.length + (controller.status.isLoadingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == data.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24, height: 24,
                              child: CircularProgressIndicator(color: Color(0xFF6366F1), strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      return _OwnerLapanganCard(
                        item: data[i],
                        onEdit: () => Get.toNamed('/owner/lapangan/form', arguments: data[i]),
                        onDelete: () => _confirmDelete(context, data[i]['id'] as int),
                      );
                    },
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
          ),
        ],
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

class _CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final void Function(String) onSelect;
  final Color accentColor;

  const _CategoryFilterBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((cat) {
            final isSelected = cat == selected;
            return GestureDetector(
              onTap: () => onSelect(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? accentColor : const Color(0xFF334155),
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: accentColor.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
          () {
            final String? foto = item['foto']?.toString();
            return Container(
              width: 48,
              height: 48,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: foto == null || foto.isEmpty
                    ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)])
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: foto != null && foto.isNotEmpty
                  ? Image.network(
                      '${ApiService.storageUrl}$foto',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.sports_soccer, color: Colors.white, size: 24),
                    )
                  : const Icon(Icons.sports_soccer, color: Colors.white, size: 24),
            );
          }(),
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
