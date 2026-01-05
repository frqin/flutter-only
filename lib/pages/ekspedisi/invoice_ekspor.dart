import 'package:ekspedisi/pages/ekspedisi/detail_invoice.dart';
import 'package:ekspedisi/services/invoice_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InvoiceEksporPage extends StatefulWidget {
  const InvoiceEksporPage({super.key});

  @override
  State<InvoiceEksporPage> createState() => _InvoiceEksporPageState();
}

class _InvoiceEksporPageState extends State<InvoiceEksporPage> {
  List<Map<String, dynamic>> invoices = [];
  List<Map<String, dynamic>> filtered = [];

  bool isLoading = true;
  String? errorMessage;

  // ⚠️ sementara hardcode token (ganti dari SharedPreferences / auth)
  final String token = 'ISI_TOKEN_DISINI';

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    try {
      final data = await InvoiceService.getAllInvoices(token);
      setState(() {
        invoices = data;
        filtered = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(LucideIcons.arrowLeft, size: 26),
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.search,
                            size: 22,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Cari invoice , kapal atau pelabuhan",
                              ),
                              onChanged: (value) {
                                final q = value.toLowerCase();
                                setState(() {
                                  filtered = invoices.where((inv) {
                                    return inv["no"].toLowerCase().contains(
                                          q,
                                        ) ||
                                        inv["kapal"].toLowerCase().contains(
                                          q,
                                        ) ||
                                        inv["from"].toLowerCase().contains(q) ||
                                        inv["to"].toLowerCase().contains(q);
                                  }).toList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Ringkasan card (BELUM DINAMIS – STEP 2)
                    Row(
                      children: [
                        Expanded(
                          child: _summaryCard(
                            title: "Total piutang",
                            value: "-",
                            icon: LucideIcons.lineChart,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _summaryCard(
                            title: "Terbayar",
                            value: "-",
                            icon: LucideIcons.badgeCheck,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // List invoice
                    Column(
                      children: filtered.map((inv) {
                        return _invoiceCard(
                          noInvoice: inv["no"],
                          status: inv["status"],
                          kapal: inv["kapal"],
                          deskripsi: inv["deskripsi"],
                          from: inv["from"],
                          to: inv["to"],
                          total: inv["total"],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ===== SUMMARY CARD =====
  static Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== INVOICE CARD =====
  Widget _invoiceCard({
    required String noInvoice,
    required String status,
    required String kapal,
    required String deskripsi,
    required String from,
    required String to,
    required int total,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailInvoicePage(
              no: noInvoice,
              status: status,
              kapal: kapal,
              deskripsi: deskripsi,
              from: from,
              to: to,
              total: total,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  noInvoice,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status == "Lunas"
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      color: status == "Lunas"
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.ship, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        kapal,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(deskripsi, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "$from  →  $to",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Total Invoice",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 3),
            Text(
              "Rp ${total.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]}.')}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
