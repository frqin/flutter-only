import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilPage extends StatefulWidget {
  final String? currentName;
  final String? currentUsername;
  final String? currentImagePath;

  const EditProfilPage({
    super.key,
    this.currentName,
    this.currentUsername,
    this.currentImagePath,
  });

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _usernameController = TextEditingController(text: widget.currentUsername);
    _passwordController = TextEditingController();

    // Load existing image if available
    if (widget.currentImagePath != null) {
      _imageFile = File(widget.currentImagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk pilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    // Kembalikan data ke halaman sebelumnya
    Navigator.pop(context, {
      'name': _nameController.text,
      'username': _usernameController.text,
      'imagePath': _imageFile?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================
      // BOTTOM NAV
      // ============================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -38),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.truck, size: 30),
              ),
            ),
          ],
        ),
      ),

      // ============================
      // MAIN CONTENT
      // ============================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================
              // HEADER BACK + TITLE (CENTERED)
              // ============================
              Stack(
                alignment: Alignment.center,
                children: [
                  // TOMBOL BACK DI KIRI
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // TITLE DI TENGAH
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ============================
              // FOTO PROFIL
              // ============================
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage("assets/images/profile.jpg")
                                as ImageProvider,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(LucideIcons.pencil, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================
              // INPUT: NAMA LENGKAP
              // ============================
              const Text(
                "Nama Lengkap",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),

              // ============================
              // INPUT: NAMA PENGGUNA
              // ============================
              const Text(
                "Nama Pengguna",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _usernameController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),

              // ============================
              // INPUT: PASSWORD
              // ============================
              const Text(
                "Password",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration(),
              ),

              const SizedBox(height: 30),

              // ============================
              // BUTTON SIMPAN
              // ============================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F2F2F),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
