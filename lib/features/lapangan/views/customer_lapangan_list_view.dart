import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_lapangan_controller.dart';

class CustomerLapanganListView extends GetView<CustomerLapanganController> {
  const CustomerLapanganListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
          const SizedBox(height: 16),
          Expanded(
            child: controller.obx(
              (data) => RefreshIndicator(
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
                    return _LapanganCard(item: data[i]);
                  },
                ),
              ),
              onLoading: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 5,
                itemBuilder: (_, __) => const _ShimmerCard(),
              ),
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
          ),
        ],
      ),
    );
  }
}

class _LapanganCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _LapanganCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String nama = item['nama_lapangan']?.toString() ?? item['nama']?.toString() ?? '-';
    final String lokasi = item['lokasi']?.toString() ?? '-';
    final String harga = item['harga_per_jam']?.toString() ?? '0';
    final String? gambar = item['gambar']?.toString();

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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gambar == null ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]) : null,
                image: gambar != null ? DecorationImage(image: NetworkImage(gambar), fit: BoxFit.cover) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: gambar == null ? const Icon(Icons.sports_soccer, color: Colors.white, size: 28) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lokasi,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Rp $harga/jam',
              style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.2, end: 0.6).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF334155).withOpacity(_anim.value)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155).withOpacity(_anim.value),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: const Color(0xFF334155).withOpacity(_anim.value),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 14,
                      color: const Color(0xFF334155).withOpacity(_anim.value),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 16,
                color: const Color(0xFF334155).withOpacity(_anim.value),
              ),
            ],
          ),
        );
      },
    );
  }
}
