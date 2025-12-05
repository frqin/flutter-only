import 'package:ekspedisi/pages/home/detailApprove.dart';
import 'package:ekspedisi/pages/profile/profilepage.dart';
import 'package:ekspedisi/pages/purchasing/Dashbord_purchasing.dart';
import 'package:flutter/material.dart';
import 'package:ekspedisi/pages/riwayat/riwayat_page.dart';
import 'package:ekspedisi/pages/ekspedisi/dashboard_ekspedisi.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hai, Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'InriaSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Jelajahi halaman dashboard',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Text(
                        'Perlu Disetujui',
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // List akan diisi dari backend
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 5, // contoh 5 item
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailApprovePage(),
                                ),
                              );
                              // aksi ketika diklik
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ICON KIRI (Lucide)
                                  const Icon(
                                    LucideIcons.send,
                                    size: 38,
                                    color: Colors.black87,
                                  ),

                                  const SizedBox(width: 16),

                                  // TEKS TENGAH
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ekspedisi ${index + 1} (WG-01 TMP)',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'InriaSans',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          '12.03 PM - 06 NOVEMBER 2025',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'InriaSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // TEKS KANAN
                                  const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      'Klik untuk melanjutkan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontFamily: 'InriaSans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardEkspedisiPage(),
                  ),
                );
              },
              child: _buildNavItem(Icons.local_shipping, 'Ekspedisi', true),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilPage()),
                );
              },
              child: _buildNavItem(
                Icons.person_outline_outlined,
                'Profil',
                true,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchasingDashboardPage(),
                  ),
                );
              },
              child: _buildNavItem(
                Icons.shopping_cart_checkout_outlined,
                'Purchasing',
                true,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiwayatApprovePage(),
                  ),
                );
              },
              child: _buildNavItem(Icons.history, 'Riwayat', true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
