import 'package:flutter/material.dart';
import 'package:ekspedisi/models/ScrapItem.dart';

class AddScrapPage extends StatefulWidget {
  const AddScrapPage({super.key});

  @override
  State<AddScrapPage> createState() => _AddScrapPageState();
}

class _AddScrapPageState extends State<AddScrapPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorPab = TextEditingController();
  DateTime _tanggalPab = DateTime.now();
  final TextEditingController _nomor = TextEditingController();
  DateTime _tanggal = DateTime.now();
  final TextEditingController _kodeBarang = TextEditingController();
  final TextEditingController _namaBarang = TextEditingController();
  final TextEditingController _satuan = TextEditingController(text: 'pcs');
  final TextEditingController _jumlah = TextEditingController();
  final TextEditingController _nilai = TextEditingController();
  final TextEditingController _keterangan = TextEditingController();

  @override
  void dispose() {
    _nomorPab.dispose();
    _nomor.dispose();
    _kodeBarang.dispose();
    _namaBarang.dispose();
    _satuan.dispose();
    _jumlah.dispose();
    _nilai.dispose();
    _keterangan.dispose();
    super.dispose();
  }

  Future<void> _pickTanggalPab() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPab,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggalPab = picked);
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final item = ScrapItem(
      nomorPab: _nomorPab.text.trim(),
      tanggalPab: _tanggalPab,
      nomor: _nomor.text.trim().isEmpty
          ? 'SCR-${DateTime.now().millisecondsSinceEpoch}'
          : _nomor.text.trim(),
      tanggal: _tanggal,
      kodeBarang: _kodeBarang.text.trim(),
      namaBarang: _namaBarang.text.trim(),
      satuan: _satuan.text.trim(),
      jumlah: int.tryParse(_jumlah.text.trim()) ?? 0,
      nilai: int.tryParse(_nilai.text.trim()) ?? 0,
      keterangan: _keterangan.text.trim(),
    );

    Navigator.pop(context, item);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Tambah Scrap',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'InriaSans',
          ),
        ),

        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Nomor Pabean, Tanggal Pabean, No Seri
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Nomor Pabean'),
                                const SizedBox(height: 8),
                                _textField(
                                  _nomorPab,
                                  'No Pabean',
                                  validator: (v) => v!.isEmpty
                                      ? 'Nomor PAB wajib diisi'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Tanggal Pabean'),
                                const SizedBox(height: 8),
                                _dateField(_tanggalPab, _pickTanggalPab),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('No Seri'),
                                const SizedBox(height: 8),
                                _textField(_nomor, 'No Seri'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Row 2: Nomor, Tanggal
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Nomor'),
                                const SizedBox(height: 8),
                                _textField(
                                  TextEditingController(
                                    text: '000031/KBC.0903/2025',
                                  ),
                                  '000031/KBC.0903/2025',
                                  enabled: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Tanggal'),
                                const SizedBox(height: 8),
                                _dateTimeField(_tanggal, _pickTanggal),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bahan Dropdown
                      _label('Bahan'),
                      const SizedBox(height: 8),
                      _dropdownField(
                        'Pilih Bahan',
                        ['Bahan 1', 'Bahan 2', 'Bahan 3'],
                        (value) {
                          // Handle selection
                        },
                      ),
                      const SizedBox(height: 20),

                      // Row 3: Jumlah, Nilai
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Jumlah'),
                                const SizedBox(height: 8),
                                _textField(
                                  _jumlah,
                                  'Jumlah',
                                  keyboard: TextInputType.number,
                                  validator: (v) =>
                                      (int.tryParse(v ?? '') ?? 0) <= 0
                                      ? 'Jumlah harus > 0'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Nilai'),
                                const SizedBox(height: 8),
                                _textField(
                                  _nilai,
                                  'Nilai',
                                  keyboard: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Tambah',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _cancel,
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text(
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------- Reusable UI ----------------------

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _textField(
    TextEditingController c,
    String hint, {
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: c,
      validator: validator,
      keyboardType: keyboard,
      enabled: enabled,
      style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _dateField(DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeField(DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _dropdownField(
    String hint,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        isExpanded: true,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
