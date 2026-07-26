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
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066CC),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1D1D1F),
            ),
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
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(() => _buildDateFilterPill(context)),
          ),
        ],
      ),
      body: controller.obx(
        (data) {
          final double totalRevenueNum = double.tryParse((data?['total_pendapatan'] ?? 0).toString()) ?? 0;
          final revenueStr = currencyFormatter.format(totalRevenueNum);
          final int countNum = int.tryParse((data?['total_lapangan'] ?? data?['total_lapangans'] ?? data?['lapangan_count'] ?? 0).toString()) ?? 0;
          final count = countNum.toString();
          final chartData = List<dynamic>.from(data?['analytics'] as List? ?? []);
          final recentTransactions = List<dynamic>.from(data?['recent_transactions'] as List? ?? []);
          final recentWithdrawals = List<dynamic>.from(data?['recent_withdrawals'] as List? ?? []);

          return RefreshIndicator(
            color: const Color(0xFF0066CC),
            onRefresh: () => controller.fetchDashboardData(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          "Total Revenue",
                          revenueStr,
                          const Color(0xFF0066CC),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          "Total Lapangan",
                          count,
                          const Color(0xFF1D1D1F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Revenue Distribution",
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (chartData.isEmpty)
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF334155), width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          "Belum ada data distribusi.",
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 280,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF334155), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: chartData.map((d) => _buildBar(d as Map<String, dynamic>)).toList(),
                      ),
                    ),
                  const SizedBox(height: 32),
                  const Text(
                    "Transaksi Terbaru",
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (recentTransactions.isEmpty)
                    const Text("Belum ada transaksi.", style: TextStyle(color: Color(0xFF94A3B8)))
                  else
                    ...recentTransactions.map((trx) {
                      final trxMap = trx as Map<String, dynamic>;
                      final double grossAmount = double.tryParse((trxMap['gross_amount'] ?? 0).toString()) ?? 0;
                      final status = trxMap['status_pembayaran'] ?? '-';
                      final lapangan = trxMap['pemesanan']?['lapangan']?['nama_lapangan'] ?? 'Lapangan';

                      return GestureDetector(
                        onTap: () {
                          if (status == 'success' || status == 'lunas' || status == 'paid') {
                            InvoiceDialog.show(context, trxMap);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155), width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lapangan,
                                    style: const TextStyle(
                                      color: Color(0xFFF8FAFC),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Status: $status",
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                currencyFormatter.format(grossAmount),
                                style: const TextStyle(
                                  color: Color(0xFF0066CC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 32),
                  const Text(
                    "Riwayat Penarikan Saldo",
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (recentWithdrawals.isEmpty)
                    const Text("Belum ada penarikan.", style: TextStyle(color: Color(0xFF94A3B8)))
                  else
                    ...recentWithdrawals.map((wd) {
                      final wdMap = wd as Map<String, dynamic>;
                      final double amount = double.tryParse((wdMap['amount'] ?? 0).toString()) ?? 0;
                      final status = wdMap['status'] ?? 'pending';
                      final bank = wdMap['bank_name'] ?? 'Bank';
                      final account = wdMap['account_number'] ?? '-';
                      final dateStr = wdMap['created_at'] ?? '';
                      String formattedDate = dateStr;
                      if (dateStr.isNotEmpty) {
                        try {
                           final dt = DateTime.parse(dateStr);
                           formattedDate = DateFormat('d MMM yyyy', 'id_ID').format(dt);
                        } catch(e) {}
                      }

                      Color badgeColor = const Color(0xFFEAB308);
                      if (status == 'approved') badgeColor = const Color(0xFF22C55E);
                      if (status == 'rejected') badgeColor = const Color(0xFFEF4444);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$bank - $account",
                                  style: const TextStyle(
                                    color: Color(0xFFF8FAFC),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormatter.format(amount),
                                  style: const TextStyle(
                                    color: Color(0xFF0066CC),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: badgeColor.withOpacity(0.5)),
                                  ),
                                  child: Text(
                                    status.toString().toUpperCase(),
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF0066CC))),
        onError: (err) => Center(child: Text(err ?? 'Error', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color accentColor) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFFF8FAFC),
              fontSize: revenueFontSize(value),
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  double revenueFontSize(String val) => val.length > 12 ? 16 : (val.length > 8 ? 18 : 22);

  Widget _buildBar(Map<String, dynamic> data) {
    final double rawPct = double.tryParse((data['percentage'] ?? 0).toString()) ?? 0.0;
    final double pct = rawPct > 1.0 ? rawPct / 100.0 : rawPct;
    final String label = data['kategori'] ?? data['jenis_olahraga'] ?? data['day'] ?? '';
    final double totalRevenue = double.tryParse((data['total_revenue'] ?? 0).toString()) ?? 0;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${(pct * 100).toInt()}%\n${currencyFormatter.format(totalRevenue)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0066CC),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: (160 * pct).clamp(4.0, 160.0),
          decoration: const BoxDecoration(
            color: Color(0xFF0066CC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilterPill(BuildContext context) {
    final start = controller.startDate.value;
    final end = controller.endDate.value;
    final bool hasFilter = start != null && end != null;
    final formatter = DateFormat('d MMM', 'id_ID');

    final String label = hasFilter
        ? '${formatter.format(start)} - ${formatter.format(end)}'
        : 'Filter Tanggal';

    return InkWell(
      onTap: () => _openDateRangePicker(context),
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0066CC),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            if (hasFilter)
              GestureDetector(
                onTap: () => controller.resetFilter(),
                child: const Icon(Icons.close, color: Color(0xFF0066CC), size: 16),
              )
            else
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0066CC), size: 18),
          ],
        ),
      ),
    );
  }
}
