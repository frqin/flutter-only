import 'package:ekspedisi/services/scrap_service.dart';
import 'package:flutter/material.dart';
import 'package:ekspedisi/models/scrap_model.dart';

class EditScrapPage extends StatefulWidget {
  final String token;
  final ScrapModel scrap;
  final VoidCallback onSaved;

  const EditScrapPage({
    super.key,
    required this.token,
    required this.scrap,
    required this.onSaved,
  });

  @override
  State<EditScrapPage> createState() => _EditScrapPageState();
}

class _EditScrapPageState extends State<EditScrapPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nopabeanController;
  late TextEditingController _noseriController;
  late TextEditingController _kodeBarangController;
  late TextEditingController _jumlahController;
  late TextEditingController _nilaiController;
  late TextEditingController _nomorController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nopabeanController = TextEditingController(text: widget.scrap.nopabean);

    _noseriController = TextEditingController(text: widget.scrap.noseri);

    _kodeBarangController = TextEditingController(
      text: widget.scrap.kodeBarang,
    );

    _jumlahController = TextEditingController(text: widget.scrap.jumlah);

    _nilaiController = TextEditingController(text: widget.scrap.nilai);

    _nomorController = TextEditingController(text: widget.scrap.nomor);
  }

  @override
  void dispose() {
    _nopabeanController.dispose();
    _noseriController.dispose();
    _kodeBarangController.dispose();
    _jumlahController.dispose();
    _nilaiController.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  Future<void> _updateScrap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedData = {
        'nopabean': _nopabeanController.text,
        'noseri': _noseriController.text,
        'KodeBarang': _kodeBarangController.text,
        'jumlah': _jumlahController.text,
        'nilai': _nilaiController.text,
        'nomor': _nomorController.text,
      };

      // //Jika nanti sudah pakai API service:
      await ScrapService.update(widget.token, widget.scrap.id, updatedData);

      await Future.delayed(const Duration(seconds: 1)); // simulasi API

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Scrap'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_note, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Perbarui data scrap dengan benar',
                      style: TextStyle(color: Colors.orange[700], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            _buildTextField('No Pabean', _nopabeanController, Icons.receipt),

            _buildTextField('No Seri', _noseriController, Icons.numbers),

            _buildTextField(
              'Kode Barang',
              _kodeBarangController,
              Icons.qr_code,
            ),

            _buildTextField(
              'Jumlah',
              _jumlahController,
              Icons.inventory,
              isNumber: true,
            ),

            _buildTextField(
              'Nilai',
              _nilaiController,
              Icons.attach_money,
              isNumber: true,
            ),

            _buildTextField('Nomor', _nomorController, Icons.tag),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _updateScrap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F2F2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (val) {
          if (val?.isEmpty ?? true) {
            return '$label tidak boleh kosong';
          }

          if (isNumber && double.tryParse(val!) == null) {
            return '$label harus berupa angka';
          }

          return null;
        },
      ),
    );
  }
}
