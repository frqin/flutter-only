// models/surat_jalan_model.dart

class SuratJalan {
  final String noSJ;
  final DateTime tanggal;
  final String noOrder;
  final String customer;
  final String ekspedisi;
  final String status;

  SuratJalan({
    required this.noSJ,
    required this.tanggal,
    required this.noOrder,
    required this.customer,
    required this.ekspedisi,
    required this.status,
  });

  // Method untuk konversi ke Map (untuk database/API)
  Map<String, dynamic> toMap() {
    return {
      'noSJ': noSJ,
      'tanggal': tanggal.toIso8601String(),
      'noOrder': noOrder,
      'customer': customer,
      'ekspedisi': ekspedisi,
      'status': status,
    };
  }

  // Method untuk membuat object dari Map (dari database/API)
  factory SuratJalan.fromMap(Map<String, dynamic> map) {
    return SuratJalan(
      noSJ: map['noSJ'] ?? '',
      tanggal: DateTime.parse(map['tanggal']),
      noOrder: map['noOrder'] ?? '',
      customer: map['customer'] ?? '',
      ekspedisi: map['ekspedisi'] ?? '',
      status: map['status'] ?? '',
    );
  }

  // Method untuk membuat copy dengan perubahan tertentu
  SuratJalan copyWith({
    String? noSJ,
    DateTime? tanggal,
    String? noOrder,
    String? customer,
    String? ekspedisi,
    String? status,
  }) {
    return SuratJalan(
      noSJ: noSJ ?? this.noSJ,
      tanggal: tanggal ?? this.tanggal,
      noOrder: noOrder ?? this.noOrder,
      customer: customer ?? this.customer,
      ekspedisi: ekspedisi ?? this.ekspedisi,
      status: status ?? this.status,
    );
  }
}
