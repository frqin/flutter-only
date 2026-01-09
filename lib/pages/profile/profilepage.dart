import 'package:ekspedisi/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // ================= SERVICE =================
  final ProfileService _profileService = ProfileService();

  // SEMENTARA: ambil dari login
  final String _nrp = '240802'; // nanti ganti dari login

  String _name = "ABCDEFGHIJK";
  String _jabatan = ""; // 🔥 GANTI EMAIL → JABATAN
  String? _photo;

  late String _lastLogin;

  @override
  void initState() {
    super.initState();
    _updateLoginTime();
    _loadProfile();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadProfile() async {
    try {
      final response = await _profileService.getProfileByNrp(_nrp);
      debugPrint('PROFILE API RESPONSE: $response');

      final data = response is List ? response[0] : response;

      setState(() {
        _name = data['namaPegawai'] ?? _name;
        _jabatan = data['jabatan'] ?? '';
        _photo = data['photo'];
      });
    } catch (e) {
      debugPrint('Load profile error: $e');
    }
  }

  // ================= LOGIN TIME =================
  void _updateLoginTime() {
    final now = DateTime.now();
    _lastLogin = DateFormat('dd MMM yyyy - HH.mm', 'id_ID').format(now);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
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
                          const SizedBox(height: 20),
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
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white24,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundImage:
                                  _photo != null && _photo!.isNotEmpty
                                  ? NetworkImage(
                                      'https://erp.pt-nikkatsu.com/media_library/pegawai/pegawai.png',
                                    )
                                  : const AssetImage(
                                          "assets/images/profile.jpg",
                                        )
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
                            _jabatan.isNotEmpty
                                ? _jabatan
                                : 'Jabatan tidak diatur',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 13,
                              fontFamily: 'InriaSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
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
                          child: const Icon(LucideIcons.clock, size: 18),
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
        ],
      ),
    );
  }
}
