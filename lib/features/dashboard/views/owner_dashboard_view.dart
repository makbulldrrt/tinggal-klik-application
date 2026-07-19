import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/owner_dashboard_controller.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Dashboard Owner', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () => Get.toNamed('/owner/lapangan'),
          ),
        ],
      ),
      body: controller.obx(
        (data) {
          final totalPendapatan = data?['total_pendapatan'] ?? 0;
          final totalLapangan = data?['total_lapangan'] ?? 0;
          final recent = data?['recent_transactions'] as List? ?? [];

          return RefreshIndicator(
            onRefresh: () => controller.fetchDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Total Pendapatan',
                        value: 'Rp $totalPendapatan',
                        icon: Icons.attach_money,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Total Lapangan',
                        value: '$totalLapangan',
                        icon: Icons.sports_soccer,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Transaksi Terbaru',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (recent.isEmpty)
                  const Text('Belum ada transaksi.', style: TextStyle(color: Color(0xFF94A3B8)))
                else
                  ...recent.map((trx) {
                    final grossAmount = trx['gross_amount'] ?? 0;
                    final status = trx['status_pembayaran'] ?? '-';
                    final lapangan = trx['pemesanan']?['lapangan']?['nama_lapangan'] ?? 'Lapangan';
                    
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(lapangan, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: Text('Status: $status', style: const TextStyle(color: Color(0xFF94A3B8))),
                        trailing: Text('Rp $grossAmount', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
        onError: (err) => Center(child: Text(err ?? 'Error', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
