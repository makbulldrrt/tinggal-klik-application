import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
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
  }
}
