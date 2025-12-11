import 'package:ekspedisi/pages/home/detailApprove.dart';
import 'package:ekspedisi/pages/profile/profilepage.dart';
import 'package:ekspedisi/pages/purchasing/Dashbord_purchasing.dart';
import 'package:flutter/material.dart';
import 'package:ekspedisi/pages/riwayat/riwayat_page.dart';
import 'package:ekspedisi/pages/ekspedisi/dashboard_ekspedisi.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ekspedisi/services/dashboard_service.dart';

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
              child: FutureBuilder<List<ApprovalItem>>(
                future: DashboardService.getApprovalList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data'));
                  } else {
                    final items = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailApprovePage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  LucideIcons.send,
                                  size: 38,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'InriaSans',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontFamily: 'InriaSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                    );
                  }
                },
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
