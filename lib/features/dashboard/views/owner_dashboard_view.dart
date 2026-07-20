import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/owner_dashboard_controller.dart';
import '../../shared/widgets/invoice_dialog.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({super.key});

  Future<void> _openDateRangePicker(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: now,
      initialDateRange: controller.startDate.value != null && controller.endDate.value != null
          ? DateTimeRange(start: controller.startDate.value!, end: controller.endDate.value!)
          : null,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
              secondary: Color(0xFF6366F1),
            ),
            dialogBackgroundColor: const Color(0xFF0F172A),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      await controller.updateDateRange(range.start, range.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
                const SizedBox(height: 16),
                _AnalyticsChart(data: data?['analytics'] as List? ?? []),
                const SizedBox(height: 16),
                Obx(() => _DateRangeChip(
                  startDate: controller.startDate.value,
                  endDate: controller.endDate.value,
                  onTap: () => _openDateRangePicker(context),
                  onClear: () => controller.resetFilter(),
                )),
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

                    return GestureDetector(
                      onTap: () {
                        if (status == 'success' || status == 'lunas' || status == 'paid') {
                          InvoiceDialog.show(context, trx);
                        }
                      },
                      child: Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(lapangan, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text('Status: $status', style: const TextStyle(color: Color(0xFF94A3B8))),
                          trailing: Text('Rp $grossAmount', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                        ),
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

class _DateRangeChip extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateRangeChip({
    required this.startDate,
    required this.endDate,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilter = startDate != null && endDate != null;
    final formatter = DateFormat('d MMM yyyy', 'id_ID');
    final label = hasFilter
        ? '${formatter.format(startDate!)} - ${formatter.format(endDate!)}'
        : 'Filter Rentang Tanggal';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: hasFilter ? const Color(0xFF312E81) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasFilter ? const Color(0xFF6366F1) : const Color(0xFF334155),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilter ? Icons.calendar_month_rounded : Icons.calendar_month_rounded,
              size: 16,
              color: hasFilter ? const Color(0xFFA5B4FC) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: hasFilter ? const Color(0xFFA5B4FC) : const Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: hasFilter ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasFilter) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Color(0xFFA5B4FC),
                ),
              ),
            ],
          ],
        ),
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

class _AnalyticsChart extends StatelessWidget {
  final List<dynamic> data;
  const _AnalyticsChart({required this.data});

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'futsal': return const Color(0xFF10B981);
      case 'badminton': return const Color(0xFF3B82F6);
      case 'basket': return const Color(0xFFF59E0B);
      case 'tenis': return const Color(0xFF8B5CF6);
      default: return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    double maxRevenue = 0;
    for (var item in data) {
      final rev = double.tryParse(item['total_revenue'].toString()) ?? 0;
      if (rev > maxRevenue) maxRevenue = rev;
    }
    if (maxRevenue == 0) maxRevenue = 1;

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
          const Text('Grafik Distribusi Pendapatan', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final category = item['kategori']?.toString() ?? 'Unknown';
                final revenue = double.tryParse(item['total_revenue'].toString()) ?? 0;
                final percentage = double.tryParse(item['percentage'].toString()) ?? 0;
                final color = _getColorForCategory(category);
                final height = (revenue / maxRevenue) * 100;
                final formatted = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(revenue);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatted,
                      style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 9, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutExpo,
                      height: height > 0 ? height : 2,
                      width: 36,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        boxShadow: [
                          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, -2)),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: data.map((item) {
              final category = item['kategori']?.toString() ?? 'Unknown';
              final color = _getColorForCategory(category);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(category, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
