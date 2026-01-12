import 'package:flutter/material.dart';
import 'package:ekspedisi/models/sjumum.dart';
import 'package:ekspedisi/services/sj_umum_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SJUmumSimplePage extends StatefulWidget {
  const SJUmumSimplePage({super.key});

  @override
  State<SJUmumSimplePage> createState() => _SJUmumSimplePageState();
}

class _SJUmumSimplePageState extends State<SJUmumSimplePage> {
  List<SjUmum> list = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> loadData() async {
    try {
      final token = await getToken();
      final data = await SjUmumService.fetchSJUmum(token);

      setState(() {
        list = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Surat Jalan Umum',
          style: TextStyle(
            fontFamily: 'InriaSans',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan nomor dan tanggal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.noSj,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDate(item.tanggal),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Info Barang Section
                        _buildSection(
                          icon: Icons.inventory_2_outlined,
                          title: 'Info barang',
                          children: [
                            _buildInfoRow('No Baru', item.noBaru),
                            _buildInfoRow('Jenis', item.jenis),
                            _buildInfoRow('Keterangan', item.keterangan),
                            _buildInfoRow('No Supplier', item.noSupp),
                          ],
                        ),

                        const Divider(height: 24),

                        // Pengiriman Section
                        _buildSection(
                          icon: Icons.local_shipping_outlined,
                          title: 'Pengiriman',
                          children: [
                            _buildInfoRow('Ekspedisi', item.ekspedisi),
                            _buildInfoRow('Customer', item.customer),
                            _buildInfoRow('Status', item.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';

    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Oct',
        'Nov',
        'Des',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
