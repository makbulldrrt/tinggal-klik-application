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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
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
          page: () => const OwnerLapanganListView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => OwnerLapanganController())),
        ),
        GetPage(
          name: '/owner/lapangan/form',
          page: () => const OwnerLapanganFormView(),
          binding: BindingsBuilder(() => Get.lazyPut(() => OwnerLapanganController())),
        ),
      ],
    );
  }
}
