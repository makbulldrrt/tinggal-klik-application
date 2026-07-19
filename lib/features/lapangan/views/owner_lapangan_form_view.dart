import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/owner_lapangan_controller.dart';

class OwnerLapanganFormView extends GetView<OwnerLapanganController> {
  const OwnerLapanganFormView({super.key});

  static const _jenisOptions = ['Futsal', 'Badminton', 'Basket'];

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final isEdit = args != null;

    final formKey = GlobalKey<FormState>();
    final namaCtrl = TextEditingController(text: args?['nama']?.toString());
    final hargaCtrl = TextEditingController(text: args?['harga_per_jam']?.toString());
    final deskripsiCtrl = TextEditingController(text: args?['deskripsi']?.toString());
    final selectedJenis = (args?['jenis']?.toString() ?? _jenisOptions.first).obs;
    final selectedStatus = (args?['status'] == true || args == null).obs;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          isEdit ? 'Edit Lapangan' : 'Tambah Lapangan',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: namaCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Nama Lapangan', Icons.stadium_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  key: ValueKey(selectedJenis.value),
                  initialValue: selectedJenis.value,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Jenis Olahraga', Icons.sports),
                  items: _jenisOptions
                      .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                      .toList(),
                  onChanged: (v) => selectedJenis.value = v!,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Harga per Jam (Rp)', Icons.payments_outlined),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Harga tidak boleh kosong';
                  if (int.tryParse(v) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: deskripsiCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Deskripsi (opsional)', Icons.description_outlined),
              ),
              const SizedBox(height: 20),
              Obx(
                () => SwitchListTile(
                  value: selectedStatus.value,
                  onChanged: (v) => selectedStatus.value = v,
                  title: const Text('Status Aktif', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    selectedStatus.value ? 'Lapangan tersedia' : 'Lapangan tidak aktif',
                    style: const TextStyle(color: Color(0xFF94A3B8)),
                  ),
                  activeThumbColor: const Color(0xFF6366F1),
                  tileColor: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 28),
              Obx(
                () {
                  final isLoading = controller.formStatus.value.isLoading;
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                final data = {
                                  'nama': namaCtrl.text.trim(),
                                  'jenis': selectedJenis.value,
                                  'harga_per_jam': int.parse(hargaCtrl.text.trim()),
                                  'deskripsi': deskripsiCtrl.text.trim().isEmpty ? null : deskripsiCtrl.text.trim(),
                                  'status': selectedStatus.value,
                                };
                                isEdit
                                    ? controller.editLapangan(args['id'] as int, data)
                                    : controller.create(data);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        disabledBackgroundColor: const Color(0xFF3730A3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              isEdit ? 'Simpan Perubahan' : 'Tambah Lapangan',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      errorStyle: const TextStyle(color: Color(0xFFEF4444)),
    );
  }
}
