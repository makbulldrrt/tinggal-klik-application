import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/booking_controller.dart';

class BookingHistoryView extends GetView<BookingController> {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Riwayat Booking', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: controller.obx(
        (data) => RefreshIndicator(
          onRefresh: controller.fetchHistory,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data!.length,
            itemBuilder: (_, i) => _HistoryCard(item: data[i] as Map<String, dynamic>),
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
        onEmpty: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, color: Color(0xFF475569), size: 56),
              SizedBox(height: 12),
              Text('Belum ada riwayat booking.', style: TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ),
        onError: (err) => Center(
          child: Text(err ?? 'Terjadi kesalahan.', style: const TextStyle(color: Color(0xFFEF4444))),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _HistoryCard({required this.item});

  Color _statusColor(String? status) {
    switch (status) {
      case 'success':
        return const Color(0xFF16A34A);
      case 'pending':
        return const Color(0xFFD97706);
      case 'expired':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF475569);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'success':
        return 'Berhasil';
      case 'pending':
        return 'Menunggu';
      case 'expired':
        return 'Kadaluarsa';
      default:
        return status ?? '-';
    }
  }

  String _formatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    final value = int.tryParse(amount.toString()) ?? 0;
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final String? status = item['status']?.toString();
    final lapangan = item['lapangan'] as Map<String, dynamic>?;
    final namaLapangan = lapangan?['nama']?.toString() ?? '-';
    final tanggal = (item['tanggal'] ?? item['tanggal_main'])?.toString() ?? '-';
    final jamMulai = item['jam_mulai']?.toString() ?? '-';
    final jamSelesai = item['jam_selesai']?.toString();
    final jamStr = jamSelesai != null ? '$jamMulai – $jamSelesai' : jamMulai;
    final totalHarga = item['total_harga'];
    final snapUrl = item['snap_url']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(namaLapangan,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor(status).withValues(alpha: 0.4)),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(
                      color: _statusColor(status), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF334155), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoChip(icon: Icons.calendar_today, label: tanggal),
              const SizedBox(width: 12),
              _InfoChip(icon: Icons.access_time, label: jamStr),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatRupiah(totalHarga),
                  style: const TextStyle(
                      color: Color(0xFF818CF8), fontSize: 16, fontWeight: FontWeight.bold)),
              if (status == 'pending' && snapUrl != null && snapUrl.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(snapUrl);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.payment, size: 16, color: Color(0xFFD97706)),
                  label: const Text('Lanjutkan Bayar',
                      style: TextStyle(color: Color(0xFFD97706), fontSize: 13)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFFD97706).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF64748B), size: 14),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
      ],
    );
  }
}
