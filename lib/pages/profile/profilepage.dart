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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // ===================== MAIN CONTENT =====================
          SingleChildScrollView(
            child: Column(
              children: [
                // ===================== HEADER =====================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60, bottom: 50),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'InriaSans',
                        ),
                      ),

                      const SizedBox(height: 32),

                      // FOTO PROFIL - Update berdasarkan _imagePath
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : const AssetImage("assets/images/profile.jpg")
                                    as ImageProvider,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'InriaSans',
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _username.isNotEmpty
                            ? '@$_username'
                            : 'Username tidak diatur',
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // =================== BOX EDIT PROFIL ===================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: _goToEditProfile,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            LucideIcons.edit2,
                            size: 20,
                            color: Color(0xFF1A1A1A),
                          ),
                          SizedBox(width: 14),
                          Text(
                            "Edit Profil",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                              fontFamily: 'InriaSans',
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // WAKTU LOGIN REAL-TIME
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            LucideIcons.clock,
                            size: 18,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Terakhir Login',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                                fontFamily: 'InriaSans',
                              ),
                            ),
                            Text(
                              _lastLogin,
                              style: const TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'InriaSans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 140),
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
