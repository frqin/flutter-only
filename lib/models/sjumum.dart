class SjUmum {
  final String no;
  final String noSj;
  final String tanggal;
  final String noBaru;
  final String noSupp;
  final String keterangan;
  final String jenis;
  final String ekspedisi;
  final String status;
  final String lastUpdate;
  final String userId;
  final String customer; // Tambahkan ini

  SjUmum({
    required this.no,
    required this.noSj,
    required this.tanggal,
    required this.noBaru,
    required this.noSupp,
    required this.keterangan,
    required this.jenis,
    required this.ekspedisi,
    required this.status,
    required this.lastUpdate,
    required this.userId,
    required this.customer, // Tambahkan ini
  });

  factory SjUmum.fromJson(Map<String, dynamic> json) {
    return SjUmum(
      no: json['no']?.toString() ?? '-',
      noSj: json['NoSj']?.toString() ?? '-',
      tanggal: json['Tanggal']?.toString() ?? '1970-01-01 00:00:00',
      noBaru: json['NoBaru']?.toString() ?? '-',
      noSupp: json['NoSupp']?.toString() ?? '-',
      keterangan: json['Keterangan']?.toString() ?? '-',
      jenis: json['Jenis']?.toString() ?? '-',
      ekspedisi: json['Ekspedisi']?.toString() ?? '-',
      status: json['Status']?.toString().isNotEmpty == true
          ? json['Status'].toString()
          : 'belum',
      lastUpdate: json['LastUpdate']?.toString() ?? '-',
      userId: json['UserId']?.toString() ?? '-',
      customer: json['customer']?.toString() ?? '-', // Tambahkan ini
    );
  }
}
