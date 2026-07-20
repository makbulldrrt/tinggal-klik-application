import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/customer_lapangan_controller.dart';
import '../../../app/data/services/api_service.dart';

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

        final lokasi = detail['lokasi']?.toString() ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final data = controller.selectedDetail.value;
                if (data == null) return const SizedBox();

                final photoPath = data['foto_lapangan'];
                final bool hasPhoto = photoPath != null && photoPath.toString().isNotEmpty;
                final String fullImageUrl = hasPhoto ? '${ApiService.baseUrl}/storage/$photoPath' : '';

                return Container(
                  width: double.infinity,
                  height: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: hasPhoto
                      ? Image.network(
                          fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Failed to load image: $fullImageUrl');
                            return const Icon(Icons.sports_soccer, size: 80, color: Colors.white);
                          },
                        )
                      : const Icon(Icons.sports_soccer, size: 80, color: Colors.white),
                );
              }),
              const SizedBox(height: 24),
              _DetailRow(label: 'Nama', value: detail['nama']?.toString()),
              _DetailRow(label: 'Jenis', value: detail['jenis']?.toString()),
              _DetailRow(label: 'Harga/Jam', value: 'Rp ${detail['harga_per_jam']?.toString()}'),
              _DetailRow(label: 'Status', value: (detail['status'] == true) ? 'Tersedia' : 'Tidak Tersedia'),
              _DetailRow(label: 'Deskripsi', value: detail['deskripsi']?.toString()),
              if (lokasi.isNotEmpty) ...[
                const SizedBox(height: 8),
                _LocationMapPanel(lokasi: lokasi),
                const SizedBox(height: 16),
              ],
              Obx(() => _ReviewsSection(
                reviews: detail['reviews'] as List? ?? [],
                selectedFilter: controller.selectedStarFilter.value,
                onSelectFilter: controller.selectStarFilter,
              )),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final detail = controller.selectedDetail.value;
        if (detail == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            border: Border(top: BorderSide(color: Color(0xFF334155))),
          ),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/customer/booking', arguments: detail);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Pesan Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _LocationMapPanel extends StatelessWidget {
  final String lokasi;
  const _LocationMapPanel({required this.lokasi});

  Future<void> _openMaps() async {
    final encoded = Uri.encodeComponent(lokasi);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                color: const Color(0xFF0D1B2A),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemCount: 64,
                  itemBuilder: (_, __) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1E3A5F).withValues(alpha: 0.5), width: 0.5),
                    ),
                  ),
                ),
              ),
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Color(0xFFEF4444), size: 40),
                      SizedBox(height: 2),
                      SizedBox(
                        width: 6, height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined, size: 11, color: Color(0xFF94A3B8)),
                      SizedBox(width: 4),
                      Text('Peta Lokasi', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        lokasi,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openMaps,
                    icon: const Icon(Icons.directions_outlined, size: 16, color: Color(0xFF10B981)),
                    label: const Text(
                      'Buka Petunjuk Rute & Google Maps',
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

class _ReviewsSection extends StatelessWidget {
  final List<dynamic> reviews;
  final String selectedFilter;
  final void Function(String) onSelectFilter;

  const _ReviewsSection({
    required this.reviews,
    required this.selectedFilter,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['Semua', '⭐ 5', '⭐ 4', '⭐ 3', '⭐ 2', '⭐ 1'];
    
    List<dynamic> filteredReviews = reviews;
    if (selectedFilter != 'Semua') {
      final targetRating = int.tryParse(selectedFilter.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      filteredReviews = reviews.where((r) {
        final review = r as Map<String, dynamic>? ?? {};
        final rating = (review['rating'] as num?)?.toInt() ?? 0;
        return rating == targetRating;
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Ulasan Pengguna',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF312E81),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${filteredReviews.length}',
                style: const TextStyle(color: Color(0xFFA5B4FC), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == selectedFilter;
              return GestureDetector(
                onTap: () => onSelectFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (filteredReviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Text(
              'Belum ada ulasan untuk rating ini.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...filteredReviews.map((r) {
            final review = r as Map<String, dynamic>? ?? {};
            return _ReviewCard(review: review);
          }),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF334155)),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final user = review['user'] as Map<String, dynamic>? ?? {};
    final name = user['name']?.toString() ?? 'A';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final komentar = review['komentar']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF4338CA),
                child: Text(
                  initial,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 14,
                        color: i < rating ? const Color(0xFFF59E0B) : const Color(0xFF475569),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (komentar.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              komentar,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}
