import 'package:ekspedisi/models/sjumum.dart';
import 'package:ekspedisi/services/sj_umum_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SJUmumPage extends StatefulWidget {
  const SJUmumPage({super.key});

  @override
  State<SJUmumPage> createState() => _SJUmumPageState();
}

class _SJUmumPageState extends State<SJUmumPage> {
  File? _ttdImage;
  final ImagePicker _picker = ImagePicker();

  List<SjUmum> barangList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSJUmum();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> loadSJUmum() async {
    try {
      final token = await getToken();
      final data = await SjUmumService.fetchSJUmum(token);

      setState(() {
        barangList = data.where((e) => e.noSj != null).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR SJ UMUM: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2F2F2F)),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Surat Jalan Umum",
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F2F2F),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F2F2F)),
              ),
            )
          : barangList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.packageOpen,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak ada data",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadSJUmum,
              color: const Color(0xFF2F2F2F),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: barangList.length,
                itemBuilder: (context, index) {
                  return buildSJCard(barangList[index]);
                },
              ),
            ),
    );
  }

  Widget buildSJCard(SjUmum item) {
    // Tracking status
    String trackingStatus = "Draft";
    Color statusColor = Colors.grey.shade600;
    IconData statusIcon = LucideIcons.fileEdit;

    final status = item.status.toLowerCase();
    if (status.contains("kirim")) {
      trackingStatus = "Dikirim";
      statusColor = const Color(0xFFFFA726);
      statusIcon = LucideIcons.truck;
    } else if (status.contains("terima") || status.contains("disetujui")) {
      trackingStatus = "Diterima";
      statusColor = const Color(0xFF66BB6A);
      statusIcon = LucideIcons.checkCircle;
    } else if (status.contains("belum")) {
      trackingStatus = "Draft";
      statusColor = Colors.grey.shade600;
      statusIcon = LucideIcons.fileEdit;
    }

    // Format tanggal
    String formattedDate = "-";
    try {
      final date = DateTime.parse(item.tanggal);
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      formattedDate = item.tanggal;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.noSj,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        trackingStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade300),

          // INFO BARANG
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.package,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Info Barang",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildInfoRow("No. Baru", item.noBaru ?? "-"),
                const SizedBox(height: 8),
                buildInfoRow("Jenis", item.jenis),
                const SizedBox(height: 8),
                buildInfoRow("Keterangan", item.keterangan ?? "-"),
                const SizedBox(height: 8),
                buildInfoRow("No. Supplier", item.noSupp ?? "-"),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade300),

          // PENGIRIMAN
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.truck,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Pengiriman",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildInfoRow("Ekspedisi", item.ekspedisi ?? "-"),
                const SizedBox(height: 8),
                buildInfoRow("User ID", item.userId),
                const SizedBox(height: 8),
                buildInfoRow("Status Lengkap", item.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        Text(": ", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2F2F2F),
            ),
          ),
        ),
      ],
    );
  }
}
