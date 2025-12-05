import 'package:ekspedisi/pages/profile/editProfil.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String _name = "ABCDEFGHIJK";
  String _username = "";
  String? _imagePath;
  late String _lastLogin;

  @override
  void initState() {
    super.initState();
    // Set waktu login saat halaman dibuka
    _updateLoginTime();
  }

  // Fungsi untuk update waktu login
  void _updateLoginTime() {
    final now = DateTime.now();
    // Format: 11 Nov 2025 - 15.18
    _lastLogin = DateFormat('dd MMM yyyy - HH.mm', 'id_ID').format(now);
  }

  // Fungsi untuk navigasi ke edit profil dan terima data kembali
  Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilPage(
          currentName: _name,
          currentUsername: _username,
          currentImagePath: _imagePath,
        ),
      ),
    );

    // Jika ada data yang dikembalikan, update state
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'] ?? _name;
        _username = result['username'] ?? _username;
        _imagePath = result['imagePath'];
      });

      // Tampilkan notifikasi berhasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Color(0xFF2F2F2F),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BOTTOM NAV
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

      backgroundColor: Colors.white,

      body: Stack(
        children: [
          // ===================== MAIN CONTENT =====================
          SingleChildScrollView(
            child: Column(
              children: [
                // ===================== HEADER =====================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80, bottom: 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // FOTO PROFIL - Update berdasarkan _imagePath
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: _imagePath != null
                            ? FileImage(File(_imagePath!))
                            : const AssetImage("assets/images/profile.jpg")
                                  as ImageProvider,
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // =================== BOX EDIT PROFIL ===================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: _goToEditProfile,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            LucideIcons.user,
                            size: 20,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Edit profil",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 90),

                // WAKTU LOGIN REAL-TIME
                Text(
                  "Terakhir login: $_lastLogin",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),

          // =================== TOMBOL BACK ===================
          Positioned(
            top: 45,
            left: 20,
            child: InkWell(
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
