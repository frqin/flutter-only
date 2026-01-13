import 'package:flutter/material.dart';
import '../../models/invoice.dart';
import '../../services/invoice_service.dart';
import 'package:ekspedisi/pages/ekspedisi/detail_invoice.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late Future<List<Invoice>> futureData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    futureData = InvoiceService.getInvoices();
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
          'Invoice Ekspor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      body: FutureBuilder<List<Invoice>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2F2F2F)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Data invoice kosong'));
          }

          return RefreshIndicator(
            onRefresh: () async => setState(_loadData),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isDisetujui = item.status.toLowerCase() == 'disetujui';

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailInvoice(no: item.no),
                      ),
                    );

                    // AUTO REFRESH JIKA DARI DETAIL ADA UPDATE
                    if (result == true) {
                      setState(_loadData);
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
                        /// NO INVOICE
                        Text(
                          item.noInvoice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// 🔥 TANGGAL (DARI BACKEND)
                        Text(
                          item.tanggal.split(' ').first,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// TUJUAN
                        Text(item.tujuan),

                        const SizedBox(height: 10),

                        /// STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDisetujui
                                ? Colors.green.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.status.replaceAll('_', ' '),
                            style: TextStyle(
                              color: isDisetujui ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
