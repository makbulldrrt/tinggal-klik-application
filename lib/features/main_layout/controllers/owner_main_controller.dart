import 'package:get/get.dart';
import '../../../app/modules/auth/controllers/auth_controller.dart';

class OwnerMainController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
  
  void logout() {
    Get.find<AuthController>().logout();
  }
}
