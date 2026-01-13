class SjUmum {
  final String no;
  final String noSj;
  final String tanggal;
  final String noBaru;
  final String? noSupp;
  final String keterangan;
  final String jenis;
  final String ekspedisi;
  final String status;
  final String lastUpdate;
  final String userId;
  final String customer;
  final String kota;

  // detail barang
  final String produk;
  final String jumlahBrg;
  final String ketProduk;
  final String unit;

  SjUmum({
    required this.no,
    required this.noSj,
    required this.tanggal,
    required this.noBaru,
    this.noSupp,
    required this.keterangan,
    required this.jenis,
    required this.ekspedisi,
    required this.status,
    required this.lastUpdate,
    required this.userId,
    required this.customer,
    required this.kota,
    required this.produk,
    required this.jumlahBrg,
    required this.ketProduk,
    required this.unit,
  });

  factory SjUmum.fromJson(Map<String, dynamic> json) {
    return SjUmum(
      no: json['no']?.toString() ?? '-',
      noSj: json['NoSj']?.toString() ?? '-',
      tanggal: json['Tanggal']?.toString() ?? '-',
      noBaru: json['NoBaru']?.toString() ?? '-',
      noSupp: json['NoSupp']?.toString(),
      keterangan: json['Keterangan']?.toString() ?? '-',
      jenis: json['Jenis']?.toString() ?? '-',
      ekspedisi: json['Ekspedisi']?.toString() ?? '-',
      status: json['Status']?.toString() ?? '-',
      lastUpdate: json['LastUpdate']?.toString() ?? '-',
      userId: json['UserId']?.toString() ?? '-',
      customer: json['customer']?.toString() ?? '-',
      kota: json['Kota']?.toString() ?? '-',
      produk: json['Produk']?.toString() ?? '',
      jumlahBrg: json['jumlahbrg']?.toString() ?? '',
      ketProduk: json['KetProduk']?.toString() ?? '',
      unit: json['Unit']?.toString() ?? '',
    );
  }
}
