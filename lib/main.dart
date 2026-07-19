import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/services/api_service.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/auth/views/login_view.dart';
import 'app/modules/auth/views/register_view.dart';

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
        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
        ),
        GetPage(
          name: '/owner/dashboard',
          page: () => const Scaffold(
            body: Center(
              child: Text('Owner Dashboard'),
            ),
          ),
        ),
        GetPage(
          name: '/pelanggan/dashboard',
          page: () => const Scaffold(
            body: Center(
              child: Text('Pelanggan Dashboard'),
            ),
          ),
        ),
      ],
    );
  }
}
