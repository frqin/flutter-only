import 'package:flutter/material.dart';
import 'package:ekspedisi/models/scrap.dart';
import 'package:ekspedisi/services/scrap_service.dart';

class DetailScrapPage extends StatefulWidget {
  final ScrapModel item;

  const DetailScrapPage({super.key, required this.item});

  @override
  State<DetailScrapPage> createState() => _DetailScrapPageState();
}

class _DetailScrapPageState extends State<DetailScrapPage> {
  bool _approved = false;
  bool _loading = false;

  // helper AMAN
  String safe(List<String> list, int index) {
    if (index >= list.length) return '-';
    return list[index].trim().isEmpty ? '-' : list[index];
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label)),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _successView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, size: 90, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Surat Jalan Berhasil Disetujui',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final produkList = item.produk.split(',');
    final jumlahList = item.jumlahBrg.split(',');
    final ketList = item.ketProduk.split(',');
    final unitList = item.unit.split(',');
    final hargaList = item.harga.split(',');
    final totalHargaList = item.totalHarga.split(',');

    final itemCount = [
      produkList.length,
      jumlahList.length,
      ketList.length,
      unitList.length,
      hargaList.length,
      totalHargaList.length,
    ].reduce((a, b) => a < b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Scrap')),
      body: _approved
          ? _successView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _row('No SJ', item.noSj),
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Detail Produk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ${safe(produkList, index)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Jumlah : ${safe(jumlahList, index)} ${safe(unitList, index)}',
                              ),
                              Text('Keterangan : ${safe(ketList, index)}'),
                              Text('Harga : ${safe(hargaList, index)}'),
                              Text(
                                'Total : ${safe(totalHargaList, index)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

      bottomNavigationBar: _approved
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          final ok = await ScrapService.setujui(widget.item.no);
                          if (ok && mounted) {
                            setState(() => _approved = true);
                          }
                          setState(() => _loading = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Setujui',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'InriaSans',
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
