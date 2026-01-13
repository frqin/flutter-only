import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardEkspedisiPage extends StatelessWidget {
  const DashboardEkspedisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ====== HEADER ======
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),

                      child: const Icon(
                        LucideIcons.arrowLeft,
                        size: 22,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard Ekspedisi",
                        style: TextStyle(
                          fontFamily: "InriaSans",
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Kelola surat jalan & invoice",
                        style: TextStyle(
                          fontFamily: "InriaSans",
                          fontSize: 13,
                          color: Color(0xFF9B9B9B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ====== CONTENT ======
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2F2F),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Selamat Datang! 👋",
                                  style: TextStyle(
                                    fontFamily: "InriaSans",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Pilih menu di bawah untuk\nmengelola ekspedisi Anda",
                                  style: TextStyle(
                                    fontFamily: "InriaSans",
                                    fontSize: 13,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.truck,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Section Title
                    const Text(
                      "Menu Utama",
                      style: TextStyle(
                        fontFamily: "InriaSans",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Pilih menu untuk melanjutkan",
                      style: TextStyle(
                        fontFamily: "InriaSans",
                        fontSize: 13,
                        color: Color(0xFF9B9B9B),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ====== MENU GRID ======
                    _MenuCard(
                      icon: LucideIcons.receipt,
                      title: "Surat Jalan Tagihan",
                      description: "Kelola surat jalan yang perlu ditagihkan",
                      onTap: () => Navigator.pushNamed(context, '/sj-tagih'),
                    ),

                    const SizedBox(height: 14),

                    _MenuCard(
                      icon: LucideIcons.fileText,
                      title: "Surat Jalan Umum",
                      description: "Surat jalan untuk pengiriman umum",
                      onTap: () => Navigator.pushNamed(context, '/sj-umum'),
                    ),

                    const SizedBox(height: 14),

                    _MenuCard(
                      icon: LucideIcons.fileCheck,
                      title: "Invoice Export",
                      description: "Buat dan kelola invoice ekspor barang",
                      onTap: () =>
                          Navigator.pushNamed(context, '/invoice-export'),
                    ),

                    const SizedBox(height: 14),

                    _MenuCard(
                      icon: LucideIcons.trash2,
                      title: "Scrap",
                      description: "Kelola barang scrap dan sisa produksi",
                      onTap: () => Navigator.pushNamed(context, '/scrap'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ====== BOTTOM NAV ======
          ],
        ),
      ),
    );
  }
}

// ===================== MENU CARD COMPONENT ==========================
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: const Color(0xFF2F2F2F)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: "InriaSans",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontFamily: "InriaSans",
                          fontSize: 12,
                          color: Color(0xFF9B9B9B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
