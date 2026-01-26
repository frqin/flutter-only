import 'package:ekspedisi/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  final String nrp;
  const ProfilPage({super.key, required this.nrp});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // ================= SERVICE =================
  final ProfileService _profileService = ProfileService();

  // ================= USER DATA =================
  late String _nrp; // ✅ FIX UTAMA
  String _name = "ABCDEFGHIJK";
  String _jabatan = "";
  String? _photo;
  late String _lastLogin;

  // ================= SETTINGS =================
  bool _whatsappNotif = false;

  @override
  void initState() {
    super.initState();
    _nrp = widget.nrp; // ✅ ambil dari Dashboard/Login
    _updateLoginTime();
    _loadProfile();
    _loadWhatsappSetting();
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

  // ================= WHATSAPP SETTING =================
  Future<void> _loadWhatsappSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _whatsappNotif = prefs.getBool('wa_notif') ?? false;
    });
  }

  Future<void> _saveWhatsappSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wa_notif', value);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
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
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: _photo != null && _photo!.isNotEmpty
                            ? NetworkImage(
                                'https://erp.pt-nikkatsu.com/media_library/pegawai/pegawai.png',
                              )
                            : const AssetImage("assets/images/profile.jpg")
                                  as ImageProvider,
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
                        _jabatan.isNotEmpty ? _jabatan : 'Jabatan tidak diatur',
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= TERAKHIR LOGIN =================
            _buildCard(
              icon: LucideIcons.clock,
              title: 'Terakhir Login',
              subtitle: _lastLogin,
            ),

            const SizedBox(height: 16),

            // ================= WHATSAPP SETTING =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    const Icon(LucideIcons.messageCircle),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifikasi WhatsApp',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Terima pemberitahuan via WhatsApp',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _whatsappNotif,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() => _whatsappNotif = value);
                        _saveWhatsappSetting(value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENT =================
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12)),
                Text(
                  subtitle,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
