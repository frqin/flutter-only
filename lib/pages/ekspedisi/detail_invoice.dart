import 'package:flutter/material.dart';
import 'package:ekspedisi/models/invoice.dart';
import 'package:ekspedisi/services/invoice_service.dart';
import 'package:intl/intl.dart';

class DetailInvoice extends StatefulWidget {
  final String no;

  const DetailInvoice({super.key, required this.no});

  @override
  State<DetailInvoice> createState() => _DetailInvoiceState();
}

class _DetailInvoiceState extends State<DetailInvoice> {
  late Future<Invoice> futureData;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    futureData = InvoiceService.getDetail(widget.no);
  }

  Future<void> _selesai(String no) async {
    final success = await InvoiceService.selesaikanInvoice(no);

    if (success) {
      setState(() => isSuccess = true);

      // balik + trigger refresh list
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context, true);
      });
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsed = DateTime.parse(date);
      return DateFormat('MMMM dd, yyyy').format(parsed);
    } catch (e) {
      return date;
    }
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
          'Detail Invoice',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      body: isSuccess ? _successView() : _detailView(),
    );
  }

  /// ================= DETAIL VIEW =================
  Widget _detailView() {
    return FutureBuilder<Invoice>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2F2F2F)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Gagal memuat detail invoice'));
        }

        final invoice = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF2F2F2F),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan logo dan info perusahaan
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Info perusahaan kiri
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'PT Nikkatsu Electric Works',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2F2F2F),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'JL. CIKAJANG NO.70\nBANDUNG 40125, INDONESIA',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF2F2F2F),
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Contact info kanan
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Text(
                                        'PHONE: 022-22-7208088',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF2F2F2F),
                                        ),
                                      ),
                                      Text(
                                        'FAX: 022-22-7208099',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF2F2F2F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Invoice Number dan Date
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'INVOICE No.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2F2F2F),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          invoice.noInvoice,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2F2F2F),
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: invoice.status == 'Disetujui'
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      border: Border.all(
                                        color: invoice.status == 'Disetujui'
                                            ? Colors.green
                                            : Colors.orange,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      invoice.status.replaceAll('_', ' '),
                                      style: TextStyle(
                                        color: invoice.status == 'Disetujui'
                                            ? Colors.green.shade700
                                            : Colors.orange.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Date: ${_formatDate(invoice.tanggal)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, thickness: 1),

                        // Invoice Details
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailRow('Invoice of', invoice.description),
                              const SizedBox(height: 12),
                              _detailRow('Address', invoice.mess),
                              const SizedBox(height: 12),
                              _detailRow('Ship', invoice.ship),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _detailRow('From', invoice.asal),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _detailRow('To', invoice.tujuan),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, thickness: 1),

                        // Additional Info Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Additional Information',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (invoice.noLc.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _infoRow('No. L/C', invoice.noLc),
                                ),
                              Row(
                                children: [
                                  Expanded(child: _infoRow('BB', invoice.bb)),
                                  const SizedBox(width: 16),
                                  Expanded(child: _infoRow('BK', invoice.bk)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _infoRow('Ukuran', invoice.ukuran),
                              const SizedBox(height: 8),
                              _infoRow('Tanggal BL', invoice.tglBl),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _infoRow('Cost', invoice.cost),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _infoRow(
                                      'Biaya',
                                      invoice.biaya.isEmpty
                                          ? '-'
                                          : invoice.biaya,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _infoRow('Biaya 1', invoice.biaya1),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _infoRow('Biaya 2', invoice.biaya2),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _infoRow('Shipper', invoice.shipper),
                              if (invoice.urut.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _infoRow('Urut', invoice.urut),
                              ],
                              if (invoice.cetak.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _infoRow('Cetak', invoice.cetak),
                              ],
                              const SizedBox(height: 8),
                              _infoRow('Flag', invoice.flag),
                            ],
                          ),
                        ),

                        const Divider(height: 1, thickness: 1),

                        // Order Note / MARKS & NOS
                        if (invoice.orderNote.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MARKS & NOS.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  invoice.orderNote,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF2F2F2F),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const Divider(height: 1, thickness: 1),

                        // Table Header - Items
                        Container(
                          color: const Color(0xFF2F2F2F),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'QUANTITY and DESCRIPTION',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  'UNIT PRICE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  'AMOUNT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Items List
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: _buildItemsList(invoice),
                        ),

                        const Divider(height: 1, thickness: 1),

                        // Total Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border.all(
                                    color: const Color(0xFF2F2F2F),
                                  ),
                                ),
                                child: Text(
                                  _calculateGrandTotal(invoice.totalHarga),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ================= BUTTON SELESAI =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: invoice.status == 'Disetujui'
                      ? null
                      : () => _selesai(invoice.no),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F2F2F),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.4),
                    disabledForegroundColor: Colors.white.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    invoice.status == 'Disetujui' ? 'Sudah Selesai' : 'Setujui',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Items List
  Widget _buildItemsList(Invoice invoice) {
    final produkList = invoice.produk.split(',');
    final qtyList = invoice.jumlahBrg.split(',');
    final hargaList = invoice.harga.split(',');
    final totalList = invoice.totalHarga.split(',');
    final unitList = invoice.unit.split(',');

    return Column(
      children: List.generate(produkList.length, (index) {
        if (index >= qtyList.length) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  '${qtyList[index].trim()} ${index < unitList.length ? unitList[index].trim() : ""} ${produkList[index].trim()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                child: Text(
                  index < hargaList.length
                      ? '@ ¥ ${hargaList[index].trim()}'
                      : '-',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2F2F2F),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: Text(
                  index < totalList.length
                      ? '¥ ${_formatNumber(totalList[index].trim())}'
                      : '-',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F2F2F),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Format number with thousand separator
  String _formatNumber(String number) {
    try {
      final num = double.parse(number);
      final formatter = NumberFormat('#,###', 'en_US');
      return formatter.format(num);
    } catch (e) {
      return number;
    }
  }

  /// Calculate Grand Total
  String _calculateGrandTotal(String totalHarga) {
    if (totalHarga.isEmpty) return '¥ 0';

    final totals = totalHarga.split(',');
    double grandTotal = 0;

    for (var total in totals) {
      grandTotal += double.tryParse(total.trim()) ?? 0;
    }

    final formatter = NumberFormat('#,###', 'en_US');
    return '¥ ${formatter.format(grandTotal)}';
  }

  /// ================= VIEW SUKSES =================
  Widget _successView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, size: 90, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Invoice Berhasil Diselesaikan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          ': $value',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF2F2F2F),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 11)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11, color: Color(0xFF2F2F2F)),
          ),
        ),
      ],
    );
  }
}
