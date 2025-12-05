import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SJUmumPage extends StatefulWidget {
  const SJUmumPage({super.key});

  @override
  State<SJUmumPage> createState() => _SJUmumPageState();
}

class _SJUmumPageState extends State<SJUmumPage> {
  File? _ttdImage;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> barangList = [
    {"nama": "Barang A", "qty": 2, "keterangan": ""},
    {"nama": "Barang B", "qty": 1, "keterangan": ""},
    {"nama": "Barang C", "qty": 5, "keterangan": ""},
  ];

  // Fungsi untuk pilih gambar
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _ttdImage = File(pickedFile.path);
      });
    }
  }

  // Dialog pilih sumber gambar
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Sumber Gambar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'InriaSans',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(LucideIcons.camera),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.image),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // ============================
              // HEADER
              // ============================
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Surat Jalan Umum",
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 20),

              // ============================
              // FORM SURAT JALAN
              // ============================
              buildTitle("Form Surat Jalan"),
              const SizedBox(height: 14),
              buildSectionCard(
                icon: LucideIcons.fileText,
                title: "No Surat Jalan",
                child: buildInput("Nomor Surat Jalan"),
              ),
              const SizedBox(height: 12),
              buildSectionCard(
                icon: LucideIcons.user,
                title: "Penerima",
                child: buildInput("Nama Penerima"),
              ),
              const SizedBox(height: 14),
              buildSectionCard(
                icon: LucideIcons.archive,
                title: "Detail Barang",
                child: buildBarangSection(),
              ),
              const SizedBox(height: 32),

              // ============================
              // TANDA TANGAN DIGITAL
              // ============================
              buildTitle("Tanda Tangan Digital"),
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _ttdImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.upload,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Belum ada tanda tangan",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(_ttdImage!, fit: BoxFit.contain),
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_ttdImage != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _ttdImage = null;
                        });
                      },
                      icon: const Icon(LucideIcons.trash2, size: 16),
                      label: const Text("Hapus"),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(LucideIcons.upload, size: 16),
                    label: Text(_ttdImage == null ? "Upload TTD" : "Ganti TTD"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F2F2F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Approve",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'InriaSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // WIDGETS CUSTOM
  // ======================================================
  Widget buildTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "InriaSans",
        ),
      ),
    );
  }

  Widget buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget buildInput(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildBarangSection() {
    return Column(
      children: [
        // HEADER TABLE
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  "No",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Nama Barang",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(
                  "Jumlah",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Keterangan",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ROWS
        ...barangList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> b = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NO
                SizedBox(
                  width: 35,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // NAMA BARANG
                Expanded(
                  flex: 3,
                  child: Text(
                    b['nama'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // JUMLAH
                SizedBox(
                  width: 70,
                  child: Text(
                    "${b['qty']}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // KETERANGAN (Input Field)
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Ket...",
                      hintStyle: TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (v) => b['keterangan'] = v,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
