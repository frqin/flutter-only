import 'package:flutter/material.dart';
import 'package:ekspedisi/models/sjtagih.dart';
import 'package:ekspedisi/services/sj_tagih_service.dart';

class SJTagihDetailPage extends StatefulWidget {
  final String no;

  const SJTagihDetailPage({super.key, required this.no});

  @override
  State<SJTagihDetailPage> createState() => _SJTagihDetailPageState();
}

class _SJTagihDetailPageState extends State<SJTagihDetailPage> {
  late Future<SjTagihModel> futureData;

  @override
  void initState() {
    super.initState();
    futureData = SjTagihService.getByNo(widget.no);
  }

  Future<void> _setujui(String no) async {
    final success = await SjTagihService.setujui(no);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Surat Jalan berhasil disetujui'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        futureData = SjTagihService.getByNo(no);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyetujui Surat Jalan'),
          backgroundColor: Colors.red,
        ),
      );
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
          'Detail Surat Jalan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<SjTagihModel>(
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

          final item = snapshot.data!;

          final produkList = item.produk.split(',');
          final qtyList = item.jumlahBrg.split(',');
          final ketList = item.ketProduk.split(',');
          final unitList = item.unit.split(',');

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ================= DATA UTAMA =================
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                          _row('No SJ', item.noSj),
                          _row('No Order', item.noOrder),
                          _row(
                            'Tanggal',
                            '${item.tanggal.day.toString().padLeft(2, '0')}-'
                                '${item.tanggal.month.toString().padLeft(2, '0')}-'
                                '${item.tanggal.year}',
                          ),

                          _row('Customer', item.customer),
                          _row('Kota', item.kota),
                          _row('Ekspedisi', item.ekspedisi),
                          _row('Keterangan', item.keterangan),

                          const SizedBox(height: 20),
                          const Divider(),

                          /// ================= BARANG =================
                          const Text(
                            'Detail Barang',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: produkList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${produkList[index]}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'QTY : ${qtyList[index]} ${unitList[index]}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      'Keterangan : ${ketList[index]}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          /// ================= STATUS =================
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= BUTTON SETUJUI =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: item.status == 'Disetujui'
                        ? null
                        : () => _setujui(item.no),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F2F2F),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.4),
                      disabledForegroundColor: Colors.white.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      item.status == 'Disetujui'
                          ? 'Sudah Disetujui'
                          : 'Setujui',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
