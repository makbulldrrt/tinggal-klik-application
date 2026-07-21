import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/modules/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              // Branded Header
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  color: Color(0xFF1D1D1F),
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5, // Signature Apple tight tracking
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masuk ke akun Tinggal Klik Anda.",
                style: TextStyle(
                  color: Color(0xFF7A7A7A),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.374,
                  height: 1.47,
                ),
              ),
              
              const SizedBox(height: 48),

              // Email / Username Input
              _buildAppleTextField(
                label: "Email atau Nama Pengguna",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password Input
              _buildAppleTextField(
                label: "Kata Sandi",
                controller: controller.passwordController,
                obscureText: true,
              ),
              
              const SizedBox(height: 12),
              
              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => {}, // Handle forgot password
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Lupa kata sandi?",
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.224,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  return ElevatedButton(
                    onPressed: isLoading ? null : () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(), // Full-pill
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.374,
                            ),
                          ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Toggle / Register Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum punya akun? ",
                      style: TextStyle(
                        color: Color(0xFF1D1D1F),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Color(0xFF0066CC),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppleTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7), // Parchment background for inputs
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 17,
              letterSpacing: -0.374,
            ),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(
                color: Color(0xFF7A7A7A),
                fontSize: 17,
                letterSpacing: -0.374,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF0066CC), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
