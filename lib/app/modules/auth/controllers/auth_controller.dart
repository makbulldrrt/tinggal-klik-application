import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final GetStorage _box = GetStorage();

  final isLoading = false.obs;

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    isLoading.value = true;
    try {
      final response = await _apiService.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      final token = response.data['token'] as String;
      _box.write('token', token);
      _box.write('user', response.data['user']);

      Get.offAllNamed('/login');
      Get.snackbar('Berhasil', 'Akun berhasil dibuat, silakan login.');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registrasi gagal.';
      Get.snackbar('Error', message.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final role = response.data['role'] as String;

      _box.write('token', token);
      _box.write('user', response.data['user']);
      _box.write('role', role);

      if (role == 'owner') {
        Get.offAllNamed('/owner/dashboard');
      } else {
        Get.offAllNamed('/pelanggan/dashboard');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Login gagal.';
      Get.snackbar('Error', message.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _apiService.dio.post('/auth/logout');
    } on DioException catch (_) {
    } finally {
      _box.remove('token');
      _box.remove('user');
      _box.remove('role');
      isLoading.value = false;
      Get.offAllNamed('/login');
    }
  }
}
