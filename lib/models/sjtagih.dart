class SuratJalan {
  final int? no;
  final String noSJ;
  final DateTime tanggal;
  final String noOrder;
  final String customer;
  final String ekspedisi;
  final String status;

  SuratJalan({
    this.no,
    required this.noSJ,
    required this.tanggal,
    required this.noOrder,
    required this.customer,
    required this.ekspedisi,
    required this.status,
  });

  factory SuratJalan.fromJson(Map<String, dynamic> json) {
    return SuratJalan(
      no: json['no'] as int?,
      noSJ: json['NoSj'] ?? '-',
      tanggal: json['Tanggal'] != null
          ? DateTime.parse(json['Tanggal'])
          : DateTime.now(),
      noOrder: json['NoOrder'] ?? '-',
      customer: json['IdCustomer'] ?? '-',
      ekspedisi: json['Ekspedisi'] ?? '-',
      status: json['Status'] ?? '-',
    );
  }
}
