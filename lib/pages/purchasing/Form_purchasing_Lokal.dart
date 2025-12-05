import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final TextEditingController supplier = TextEditingController();
  final TextEditingController item = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController keterangan = TextEditingController();

  File? supervisorSignature;
  final picker = ImagePicker();

  Future pickSignature() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        supervisorSignature = File(img.path);
      });
    }
  }

  Widget buildInput({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ===============================
  // BOTTOM NAV

  // ===============================
  // SCAFFOLD
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      // PASANG BOTTOM NAV
      appBar: AppBar(
        title: const Text(
          "Purchase Lokal Form",
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD HEADER INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "PT. Nikkatsu Electric Works",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD INPUT FORM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildInput(
                    label: "Nama Supplier",
                    controller: supplier,
                    icon: LucideIcons.store,
                  ),
                  buildInput(
                    label: "Nama Barang/Jasa",
                    controller: item,
                    icon: LucideIcons.package,
                  ),
                  buildInput(
                    label: "Quantity",
                    controller: qty,
                    type: TextInputType.number,
                    icon: LucideIcons.hash,
                  ),
                  buildInput(
                    label: "Harga (Rp)",
                    controller: price,
                    type: TextInputType.number,
                    icon: LucideIcons.wallet,
                  ),
                  buildInput(
                    label: "Tanggal Kirim",
                    controller: date,
                    icon: LucideIcons.calendar,
                  ),
                  // KETERANGAN (Textarea)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Keterangan",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SIGNATURE SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tanda Tangan ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: pickSignature,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: supervisorSignature == null
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: supervisorSignature == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 40,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Tap untuk unggah tanda tangan",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            )
                          : Image.file(
                              supervisorSignature!,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF2F2F2F),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("BERHASIL DISIMPAN")),
                  );
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'InriaSans',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
