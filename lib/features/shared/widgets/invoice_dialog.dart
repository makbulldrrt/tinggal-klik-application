import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDialog {
  static void show(BuildContext context, Map<String, dynamic> item) {
    final statusRaw = item['status_pembayaran']?.toString();
    final status = statusRaw ?? item['status']?.toString() ?? '-';
    final isSuccess = status == 'success' || status == 'lunas' || status == 'paid';

    final orderId = item['id']?.toString() ?? '-';
    final createdAt = item['created_at']?.toString() ?? '-';

    final customerName = item['user']?['name']?.toString() ??
        item['pelanggan_name']?.toString() ??
        item['user_name']?.toString() ??
        item['pelanggan']?['name']?.toString() ??
        item['pemesanan']?['user']?['name']?.toString() ??
        'Pelanggan';

    final lapangan = item['lapangan'] ?? item['pemesanan']?['lapangan'];
    final lapanganName = lapangan?['nama_lapangan']?.toString() ?? lapangan?['nama']?.toString() ?? '-';

    final tanggal = (item['tanggal_pesan'] ?? item['tanggal'] ?? item['tanggal_main'] ?? item['pemesanan']?['tanggal_main'] ?? item['created_at'])?.toString() ?? '-';
    final jamMulai = (item['jam_mulai'] ?? item['pemesanan']?['jam_mulai'])?.toString() ?? '-';
    final jamSelesai = (item['jam_selesai'] ?? item['pemesanan']?['jam_selesai'])?.toString() ?? '-';
    final hargaPerJam = (lapangan?['harga_per_jam'] ?? item['pemesanan']?['lapangan']?['harga_per_jam'])?.toString() ?? '-';

    final totalHarga = (item['total_harga'] ?? item['gross_amount'])?.toString() ?? '0';

    final badgeColor = isSuccess ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    final badgeText = isSuccess ? '✓ PAID / SUCCESSFUL' : '⏳ PENDING';

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF1E293B), const Color(0xFF312E81).withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TINGGAL KLIK',
                              style: TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                            const Text(
                              'OFFICIAL STATEMENT',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _InfoChip(icon: Icons.tag, label: 'TRX-$orderId'),
                        const SizedBox(width: 12),
                        _InfoChip(icon: Icons.schedule, label: createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionLabel('DETAIL TRANSAKSI'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    _buildRow('Nama Pelanggan', customerName, icon: Icons.person_outline),
                    _buildDivider(),
                    _buildRow('Nama Lapangan', lapanganName, icon: Icons.sports_soccer_outlined),
                    _buildDivider(),
                    _buildRow('Tanggal Main', tanggal, icon: Icons.calendar_today_outlined),
                    _buildDivider(),
                    _buildRow('Slot Waktu', '$jamMulai – $jamSelesai', icon: Icons.access_time_outlined),
                    _buildDivider(),
                    _buildRow('Tarif per Jam', hargaPerJam != '-' ? _formatRupiah(hargaPerJam) : '-', icon: Icons.payments_outlined),
                    _buildDivider(),
                    _buildRow('Gateway', 'Midtrans Authorization', icon: Icons.verified_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Tagihan', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(
                      _formatRupiah(totalHarga),
                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: List.generate(
                  36,
                  (i) => Expanded(
                    child: Container(
                      height: 1.5,
                      color: i % 2 == 0 ? const Color(0xFF334155) : Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terima kasih telah berolahraga menggunakan Tinggal Klik!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF334155)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tutup Bukti Transaksi', style: TextStyle(color: Color(0xFF94A3B8))),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _buildSectionLabel(String text) {
    return Text(text, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2));
  }

  static Widget _buildRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 10),
          ],
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFF1F2D3D), indent: 16, endIndent: 16);
  }

  static String _formatRupiah(String amount) {
    final value = int.tryParse(amount) ?? 0;
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
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
        Icon(icon, size: 12, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
      ],
    );
  }
}
