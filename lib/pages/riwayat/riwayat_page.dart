import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RiwayatApprovePage extends StatelessWidget {
  const RiwayatApprovePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Riwayat approve",
          style: TextStyle(
            color: Color(0xFF2F2F2F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "InriaSans",
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemCount: 6,
        itemBuilder: (context, index) {
          // contoh card yang biru

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.check,
                  size: 38,
                  color: Color(0xFF2F2F2F),
                ),
                const SizedBox(width: 14),

                // TEXT AREA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Ekspedisi 1 (WG-01 TMP)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F2F2F),
                        fontFamily: "InriaSans",
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Status: Telah disetujui",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontFamily: "InriaSans",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
