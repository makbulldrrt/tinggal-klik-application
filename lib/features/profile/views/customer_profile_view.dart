import 'package:flutter/material.dart';
import 'package:get/get.dart' as import_auth;
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../app/modules/auth/controllers/auth_controller.dart' as import_auth;

class CustomerProfileView extends GetView<ProfileController> {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: controller.obx(
        (user) {
          final nameCtrl = TextEditingController(text: user?['name']?.toString());
          final emailCtrl = TextEditingController(text: user?['email']?.toString());
          final phoneCtrl = TextEditingController(text: user?['phone']?.toString());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF334155),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 32),
                _buildField('Nama Lengkap', nameCtrl),
                const SizedBox(height: 16),
                _buildField('Email', emailCtrl, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildField('Nomor HP', phoneCtrl, keyboardType: TextInputType.phone),
                const SizedBox(height: 32),
                  Obx(() {
                    final isLoading = controller.formStatus.value.isLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              controller.updateProfile(
                                nameCtrl.text.trim(),
                                emailCtrl.text.trim(),
                                phoneCtrl.text.trim(),
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    );
                  }),
                  const SizedBox(height: 32),
                  const Divider(color: Color(0xFF334155)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                    title: const Text('Keluar Akun', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                    onTap: () {
                      import_auth.Get.find<import_auth.AuthController>().logout();
                    },
                  ),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
        onError: (err) => Center(child: Text(err ?? 'Error', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController textController, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
          ),
        ),
      ],
    );
  }
}
