import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetailInvoicePage extends StatelessWidget {
  final String no;
  final String status;
  final String kapal;
  final String deskripsi;
  final String from;
  final String to;
  final int total;

  const DetailInvoicePage({
    super.key,
    required this.no,
    required this.status,
    required this.kapal,
    required this.deskripsi,
    required this.from,
    required this.to,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.arrowLeft, size: 26),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Detail Invoice",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Header: No invoice + status
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nomor Invoice",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          no,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: status == "Lunas"
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status == "Lunas"
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Card informasi kapal
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.ship, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            kapal,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      deskripsi,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "$from  →  $to",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Total
              const Text(
                "Total Invoice",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                "Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF2F2F2F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Download Invoice",
                    style: TextStyle(fontSize: 17, fontFamily: 'InriaSans'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
