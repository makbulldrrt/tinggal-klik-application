import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_main_controller.dart';
import '../../lapangan/views/customer_lapangan_list_view.dart';
import '../../booking/views/booking_history_view.dart';
import '../../profile/views/customer_profile_view.dart';

class CustomerMainLayout extends StatelessWidget {
  const CustomerMainLayout({super.key});

  static final List<Widget> _pages = [
    CustomerLapanganListView(),
    BookingHistoryView(),
    CustomerProfileView(),
  ];

  static const List<String> _titles = [
    'Katalog Lapangan',
    'Riwayat Pemesanan',
    'Profil Saya',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerMainController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
            title: Obx(() => Text(
              _titles[controller.currentIndex.value],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF334155),
                  child: Icon(Icons.person, size: 20, color: Colors.white),
                ),
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
              BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Katalog'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
          )),
    );
  }
}
