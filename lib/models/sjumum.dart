class SjUmum {
  final int no;
  final String noSj;
  final String tanggal;
  final String? noBaru;
  final String? noSupp;
  final String? keterangan;
  final String jenis;
  final String? ekspedisi;
  final String status;
  final String userId;

  SjUmum({
    required this.no,
    required this.noSj,
    required this.tanggal,
    this.noBaru,
    this.noSupp,
    this.keterangan,
    required this.jenis,
    this.ekspedisi,
    required this.status,
    required this.userId,
  });

  factory SjUmum.fromJson(Map<String, dynamic> json) {
    return SjUmum(
      no: json['no'],
      noSj: json['NoSj'],
      tanggal: json['Tanggal'],
      noBaru: json['NoBaru'],
      noSupp: json['NoSupp'],
      keterangan: json['Keterangan'],
      jenis: json['Jenis'],
      ekspedisi: json['Ekspedisi'],
      status: json['Status'],
      userId: json['UserId'].toString(),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "Tanggal": tanggal,
      "NoBaru": noBaru,
      "NoSupp": noSupp,
      "Keterangan": keterangan,
      "Jenis": jenis,
      "Ekspedisi": ekspedisi,
      "Status": status,
      "UserId": userId,
    };
  }
}
