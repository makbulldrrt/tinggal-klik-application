import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        try {
          final storage = GetStorage();
          String? token = storage.read('token');
          String? role = storage.read('role');

          if (token != null && token.isNotEmpty) {
            if (role == 'owner') {
              Get.offAllNamed('/owner-main');
            } else {
              Get.offAllNamed('/customer-main');
            }
          } else {
            Get.offAllNamed('/login');
          }
        } catch (e) {
          Get.offAllNamed('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF06B6D4), Color(0xFF10B981)],
              ).createShader(bounds),
              child: const Icon(
                Icons.stadium_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 28, color: Colors.white),
                children: [
                  TextSpan(text: 'Tinggal', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Klik', style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
