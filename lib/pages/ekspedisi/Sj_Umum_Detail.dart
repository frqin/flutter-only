import 'package:ekspedisi/models/sjumum.dart';
import 'package:ekspedisi/services/sj_umum_service.dart';
import 'package:flutter/material.dart';

class SJUmumDetailPage extends StatefulWidget {
  final SjUmum item;
  const SJUmumDetailPage({super.key, required this.item});

  @override
  State<SJUmumDetailPage> createState() => _SJUmumDetailPageState();
}

class _SJUmumDetailPageState extends State<SJUmumDetailPage> {
  late SjUmum item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<void> _setujui() async {
    final ok = await SjUmumService.setujui(item.no);
    if (ok) {
      setState(() {
        item = SjUmum(
          no: item.no,
          noSj: item.noSj,
          tanggal: item.tanggal,
          noBaru: item.noBaru,
          noSupp: item.noSupp,
          keterangan: item.keterangan,
          jenis: item.jenis,
          ekspedisi: item.ekspedisi,
          status: 'Disetujui',
          lastUpdate: item.lastUpdate,
          userId: item.userId,
          customer: item.customer,
          kota: item.kota,
          produk: item.produk,
          jumlahBrg: item.jumlahBrg,
          ketProduk: item.ketProduk,
          unit: item.unit,
        );
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil disetujui')));
    }
  }

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(width: 120, child: Text(l)),
        const Text(': '),
        Expanded(child: Text(v)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final produk = item.produk.split(',');
    final qty = item.jumlahBrg.split(',');
    final unit = item.unit.split(',');
    final ket = item.ketProduk.split(',');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Detail Surat Jalan',
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('No SJ', item.noSj),
                    _row('Tanggal', item.tanggal),
                    _row('Customer', item.customer),
                    _row('Kota Customer', item.kota),
                    _row('Ekspedisi', item.ekspedisi),
                    _row('Keterangan', item.keterangan),
                    _row('Produk', item.produk),
                    const Divider(),

                    const Text(
                      'Detail Barang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: produk.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${i + 1}. ${produk[i]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text('QTY : ${qty[i]} ${unit[i]}'),
                            Text('Keterangan : ${ket[i]}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: item.status == 'Disetujui' ? null : _setujui,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F2F2F),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.4),
                  disabledForegroundColor: Colors.white.withOpacity(0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'InriaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  item.status == 'Disetujui' ? 'Sudah Disetujui' : 'Setujui',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
