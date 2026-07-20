import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';

class OwnerWithdrawalView extends GetView<SupportController> {
  const OwnerWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    final amountCtrl = TextEditingController();
    final bankCtrl = TextEditingController();
    final accCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField('Jumlah Penarikan', amountCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildField('Nama Bank', bankCtrl),
            const SizedBox(height: 16),
            _buildField('Nomor Rekening', accCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 32),
            Obx(() {
              final isLoading = controller.withdrawalStatus.value.isLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
                        controller.submitWithdrawal(amount, bankCtrl.text.trim(), accCtrl.text.trim());
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Kirim Permintaan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              );
            }),
          ],
        ),
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
