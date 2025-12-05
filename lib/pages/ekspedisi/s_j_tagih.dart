import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ekspedisi/models/SuratTagih.dart';
import 'package:image_picker/image_picker.dart';

class SJTagihPage extends StatefulWidget {
  const SJTagihPage({Key? key}) : super(key: key);

  @override
  State<SJTagihPage> createState() => _SJTagihPageState();
}

class _SJTagihPageState extends State<SJTagihPage> {
  final List<SuratJalan> suratJalanList = [
    SuratJalan(
      noSJ: 'SJ-2024-001',
      tanggal: DateTime(2024, 11, 20),
      noOrder: 'ORD-001',
      customer: 'PT Maju Jaya',
      ekspedisi: 'JNE Regular',
      status: 'Dikirim',
    ),
    SuratJalan(
      noSJ: 'SJ-2025-002',
      tanggal: DateTime(2024, 11, 21),
      noOrder: 'ORD-002',
      customer: 'CV Berkah Sejahtera',
      ekspedisi: 'SiCepat Express',
      status: 'Dalam Proses',
    ),
    SuratJalan(
      noSJ: 'SJ-2025-003',
      tanggal: DateTime(2024, 11, 22),
      noOrder: 'ORD-003',
      customer: 'PT Sukses Makmur',
      ekspedisi: 'J&T Cargo',
      status: 'Tertagih',
    ),
    SuratJalan(
      noSJ: 'SJ-2025-004',
      tanggal: DateTime(2024, 11, 23),
      noOrder: 'ORD-004',
      customer: 'Toko Sinar Terang',
      ekspedisi: 'Anteraja',
      status: 'Dikirim',
    ),
    SuratJalan(
      noSJ: 'SJ-2025-005',
      tanggal: DateTime(2024, 11, 24),
      noOrder: 'ORD-005',
      customer: 'UD Mandiri Jaya',
      ekspedisi: 'JNE Express',
      status: 'Belum Tertagih',
    ),
  ];

  void _showDetailDialog(SuratJalan sj) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetailDialog(suratJalan: sj);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surat Jalan Tagih',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suratJalanList.length,
        itemBuilder: (context, index) {
          final sj = suratJalanList[index];
          return _buildSuratJalanCard(sj);
        },
      ),
    );
  }

  Widget _buildSuratJalanCard(SuratJalan sj) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailDialog(sj),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sj.noSJ,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F2F),
                    ),
                  ),
                  _buildStatusChip(sj.status),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.calendar_today,
                'Tanggal',
                '${sj.tanggal.day}/${sj.tanggal.month}/${sj.tanggal.year}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.receipt_long, 'No Order', sj.noOrder),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.business, 'Customer', sj.customer),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.local_shipping, 'Ekspedisi', sj.ekspedisi),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showDetailDialog(sj),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F2F2F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Detail & Upload TTD',
                  style: TextStyle(fontFamily: 'InriaSans'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF2F2F2F)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Dikirim':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      case 'Tertagih':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'Dalam Proses':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'Belum Tertagih':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DetailDialog extends StatefulWidget {
  final SuratJalan suratJalan;

  const DetailDialog({Key? key, required this.suratJalan}) : super(key: key);

  @override
  State<DetailDialog> createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  File? _signatureImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _signatureImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload Tanda Tangan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF2F2F2F),
                  ),
                  title: const Text('Ambil Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF2F2F2F),
                  ),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Surat Jalan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F2F),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('No SJ', widget.suratJalan.noSJ),
              _buildDetailRow(
                'Tanggal',
                '${widget.suratJalan.tanggal.day}/${widget.suratJalan.tanggal.month}/${widget.suratJalan.tanggal.year}',
              ),
              _buildDetailRow('No Order', widget.suratJalan.noOrder),
              _buildDetailRow('Customer', widget.suratJalan.customer),
              _buildDetailRow('Ekspedisi', widget.suratJalan.ekspedisi),
              _buildDetailRow('Status', widget.suratJalan.status),
              const SizedBox(height: 24),
              const Text(
                'Tanda Tangan Digital',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F2F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: _signatureImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _signatureImage!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.draw, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada tanda tangan',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload TTD'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2F2F2F),
                        side: const BorderSide(color: Color(0xFF2F2F2F)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (_signatureImage != null) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _signatureImage = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Surat jalan berhasil disimpan!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F2F2F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Approve',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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
