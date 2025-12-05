import 'package:flutter/material.dart';

class SeleksiPemasokPage extends StatefulWidget {
  const SeleksiPemasokPage({super.key});

  @override
  State<SeleksiPemasokPage> createState() => _SeleksiPemasokPageState();
}

class _SeleksiPemasokPageState extends State<SeleksiPemasokPage> {
  InputDecoration field(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF2F2F2F), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2F2F2F), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Seleksi Pemasok Baru",
          style: TextStyle(
            color: Color(0xFF2F2F2F),
            fontFamily: 'InriaSans',
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2F2F2F)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section A
            _buildSection("A. Identitas Perusahaan", [
              TextField(decoration: field("Nama Perusahaan")),
              const SizedBox(height: 12),
              TextField(decoration: field("Alamat Perusahaan"), maxLines: 2),
              const SizedBox(height: 12),
              TextField(decoration: field("Status Perusahaan")),
              const SizedBox(height: 12),
              TextField(decoration: field("SIUP No")),
              const SizedBox(height: 12),
              TextField(decoration: field("NPWP No")),
              const SizedBox(height: 12),
              TextField(
                decoration: field("Telepon"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(decoration: field("Fax")),
              const SizedBox(height: 12),
              TextField(
                decoration: field("E-mail"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(decoration: field("Contact Person")),
              const SizedBox(height: 12),
              TextField(decoration: field("Sertifikasi")),
              const SizedBox(height: 12),
              TextField(decoration: field("Kriteria Barang/Jasa")),
            ]),

            const SizedBox(height: 24),

            // Section B
            _buildSection("B. Faktor Seleksi", [
              TextField(decoration: field("Nama Perusahaan Baru")),
              const SizedBox(height: 12),
              TextField(decoration: field("Spesifikasi Barang"), maxLines: 2),
              const SizedBox(height: 12),
              TextField(
                decoration: field("Harga"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(decoration: field("Waktu Pengiriman")),
              const SizedBox(height: 12),
              TextField(decoration: field("Minimum Order")),
              const SizedBox(height: 12),
              TextField(decoration: field("Jangka Waktu Pembayaran")),
              const SizedBox(height: 12),
              TextField(decoration: field("Keterangan"), maxLines: 3),
            ]),

            const SizedBox(height: 24),

            // Section C
            _buildSection("C. Faktor Pembanding (Opsional)", [
              TextField(decoration: field("Nama Perusahaan Lama")),
              const SizedBox(height: 12),
              TextField(
                decoration: field("Spesifikasi Barang Lama"),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: field("Harga"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(decoration: field("Waktu Pengiriman")),
              const SizedBox(height: 12),
              TextField(decoration: field("Minimum Order")),
              const SizedBox(height: 12),
              TextField(decoration: field("Jangka Waktu Pembayaran")),
              const SizedBox(height: 12),
              TextField(decoration: field("Keterangan"), maxLines: 3),
            ]),

            const SizedBox(height: 24),

            // Section D
            _buildSection("D. Alasan Terpilih", [
              TextField(
                decoration: field("Alasan Memilih Pemasok Ini"),
                maxLines: 4,
              ),
            ]),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F2F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showSuccessDialog(context);
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F2F2F),
          ),
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Berhasil!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F2F2F),
          ),
        ),
        content: const Text(
          "Form seleksi pemasok berhasil disimpan",
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: Color(0xFF2F2F2F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
