import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/services/api_service.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/auth/views/login_view.dart';
import 'app/modules/auth/views/register_view.dart';
import 'features/lapangan/controllers/customer_lapangan_controller.dart';
import 'features/lapangan/controllers/owner_lapangan_controller.dart';
import 'features/lapangan/views/customer_lapangan_detail_view.dart';
import 'features/lapangan/views/customer_lapangan_list_view.dart';
import 'features/lapangan/views/owner_lapangan_form_view.dart';
import 'features/lapangan/views/owner_lapangan_list_view.dart';
import 'features/booking/controllers/booking_controller.dart';
import 'features/booking/views/lapangan_booking_view.dart';
import 'features/booking/views/booking_history_view.dart';
import 'features/dashboard/controllers/owner_dashboard_controller.dart';
import 'features/dashboard/views/owner_dashboard_view.dart';
import 'features/support/controllers/support_controller.dart';
import 'features/support/views/owner_withdrawal_view.dart';
import 'features/auth/views/splash_view.dart';
import 'features/auth/controllers/splash_controller.dart';
import 'features/main_layout/views/customer_main_layout.dart';
import 'features/main_layout/controllers/customer_main_controller.dart';
import 'features/main_layout/views/owner_main_layout.dart';
import 'features/main_layout/controllers/owner_main_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/profile/views/customer_profile_view.dart';
import 'features/booking/controllers/booking_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ApiService(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tinggal Klik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
        ),
        primaryColor: const Color(0xFF0F172A),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.04),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => SplashController())),
        ),
        GetPage(
          name: '/customer-main',
          page: () => const CustomerMainLayout(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => CustomerMainController());
            Get.lazyPut(() => CustomerLapanganController());
            Get.lazyPut(() => BookingController());
            Get.lazyPut(() => ProfileController());
          }),
        ),
        GetPage(
          name: '/owner-main',
          page: () => const OwnerMainLayout(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => OwnerMainController());
            Get.lazyPut(() => OwnerDashboardController());
            Get.lazyPut(() => OwnerLapanganController());
            Get.lazyPut(() => SupportController());
          }),
        ),
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/register', page: () => const RegisterView()),
        GetPage(
          name: '/pelanggan/dashboard',
          page: () => const CustomerLapanganListView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => CustomerLapanganController())),
        ),
        GetPage(
          name: '/customer/lapangan/detail',
          page: () => const CustomerLapanganDetailView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => CustomerLapanganController())),
        ),
        GetPage(
          name: '/owner/dashboard',
          page: () => const OwnerDashboardView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => OwnerDashboardController())),
        ),
        GetPage(
          name: '/owner/lapangan',
          page: () => const OwnerLapanganListView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => OwnerLapanganController())),
        ),
        GetPage(
          name: '/owner/lapangan/form',
          page: () => const OwnerLapanganFormView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => OwnerLapanganController())),
        ),
        GetPage(
          name: '/customer/booking',
          page: () => const LapanganBookingView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => BookingController())),
        ),
        GetPage(
          name: '/customer/booking/history',
          page: () => const BookingHistoryView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => BookingController())),
        ),
        GetPage(
          name: '/customer/profile',
          page: () => CustomerProfileView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => ProfileController())),
        ),
        GetPage(
          name: '/owner/withdrawal',
          page: () => const OwnerWithdrawalView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => SupportController())),
        ),
      ],
    );
  }
}
