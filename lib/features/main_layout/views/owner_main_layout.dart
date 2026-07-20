import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/owner_main_controller.dart';
import '../../dashboard/views/owner_dashboard_view.dart';
import '../../lapangan/views/owner_lapangan_list_view.dart';
import '../../support/views/owner_withdrawal_view.dart';

class OwnerMainLayout extends StatelessWidget {
  const OwnerMainLayout({super.key});

  static final List<Widget> _pages = [
    OwnerDashboardView(),
    OwnerLapanganListView(),
    OwnerWithdrawalView(),
  ];

  static const List<String> _titles = [
    'Dashboard Finansial',
    'Kelola Lapangan',
    'Tarik Saldo',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerMainController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
            title: Obx(() => Text(
              _titles[controller.currentIndex.value],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 48, color: Color(0xFFF59E0B)),
                          const SizedBox(height: 16),
                          const Text(
                            'Konfirmasi Keluar',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Apakah Anda yakin ingin keluar dari akun ini?',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: Color(0xFF334155)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Batal', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.logout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changePage(index),
            backgroundColor: const Color(0xFF0F172A),
            selectedItemColor: const Color(0xFF06B6D4),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Lapangan'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tarik'),
            ],
          )),
    );
  }
}
