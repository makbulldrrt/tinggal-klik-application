import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/data/services/api_service.dart';
import '../controllers/customer_lapangan_controller.dart';

class CustomerLapanganDetailView extends GetView<CustomerLapanganController> {
  const CustomerLapanganDetailView({super.key});

  Future<void> _openMaps(String lokasi) async {
    if (lokasi.isEmpty) return;
    final encoded = Uri.encodeComponent(lokasi);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
      body: Obx(() {
        final rawData = controller.selectedDetail.value;
        if (rawData == null || rawData.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0066CC)));
        }
        
        final data = rawData.containsKey('data') && rawData['data'] is Map ? rawData['data'] as Map<String, dynamic> : rawData;

        final String name = data['nama_lapangan'] ?? data['nama'] ?? 'Venue Name';
        final String category = data['jenis_olahraga'] ?? data['jenis'] ?? 'Sport';
        final String price = data['harga_per_jam']?.toString() ?? '0';
        final String address = data['alamat'] ?? data['lokasi'] ?? 'Location address...';
        final photoPath = data['foto_lapangan'] ?? data['foto'];
        final bool hasPhoto = photoPath != null && photoPath.toString().isNotEmpty;
        final String imageUrl = hasPhoto ? '${ApiService.baseUrl}/storage/$photoPath' : '';

        return Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    color: const Color(0xFF1E293B),
                    child: hasPhoto
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.image_not_supported, size: 80, color: Color(0xFF334155)),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.sports_soccer, size: 80, color: Color(0xFF334155)),
                          ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFFF5F5F7),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFC),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF1D1D1F),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Color(0xFF1D1D1F),
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            height: 1.14,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                "Harga",
                                "Rp $price / jam",
                                Icons.payments_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoCard(
                                "Olahraga",
                                category,
                                Icons.sports_soccer_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildWideInfoCard(
                          "Lokasi",
                          address,
                          "Buka di Maps",
                          () => _openMaps(address),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2D2D7).withValues(alpha: 0.64),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Color(0xFF1D1D1F), size: 28),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStickyBottomBar(price, data),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0066CC), size: 24),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.374,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideInfoCard(String title, String value, String linkText, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onTap,
            child: Text(
              linkText,
              style: const TextStyle(
                color: Color(0xFF0066CC),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(String price, Map<String, dynamic> data) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7).withValues(alpha: 0.8),
            border: const Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TOTAL HARGA",
                    style: TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "Rp $price / jam",
                    style: const TextStyle(
                      color: Color(0xFF1D1D1F),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/customer/booking', arguments: data);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.374,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
