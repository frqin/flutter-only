import 'package:flutter/material.dart';
import 'package:ekspedisi/models/sjtagih.dart';
import 'package:ekspedisi/services/sj_tagih_service.dart';
import 'Sj_Tagih_Detail.dart';

class SJTagihListPage extends StatefulWidget {
  const SJTagihListPage({super.key});

  @override
  State<SJTagihListPage> createState() => _SJTagihListPageState();
}

class _SJTagihListPageState extends State<SJTagihListPage> {
  late Future<List<SjTagihModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = SjTagihService.getAll(); // GET ALL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Surat Jalan Tagihan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      body: FutureBuilder<List<SjTagihModel>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2F2F2F)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Data SJ Tagih kosong'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureData = SjTagihService.getAll();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(14),

                  /// 🔴 INI BAGIAN YANG DITAMBAHKAN
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SJTagihDetailPage(no: item.no),
                      ),
                    );

                    // 🔄 JIKA DETAIL MENGEMBALIKAN true → REFRESH LIST
                    if (result == true) {
                      setState(() {
                        futureData = SjTagihService.getAll();
                      });
                    }
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NO SJ
                        Text(
                          item.noSj,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F2F2F),
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// CUSTOMER
                        Text(
                          item.customer,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// KOTA
                        Text(
                          item.kota,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// STATUS
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: item.status == 'Disetujui'
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status.replaceAll('_', ' '),
                              style: TextStyle(
                                color: item.status == 'Disetujui'
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
