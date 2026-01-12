class SjTagihModel {
  final String no;
  final String noSj;
  final String noOrder;
  final DateTime tanggal;
  final String customer;
  final String kota;
  final String ekspedisi;
  final String keterangan;
  final String produk;
  final String jumlahBrg;
  final String ketProduk;
  final String unit;
  final String status;

  SjTagihModel({
    required this.no,
    required this.noSj,
    required this.noOrder,
    required this.tanggal,
    required this.customer,
    required this.kota,
    required this.ekspedisi,
    required this.keterangan,
    required this.produk,
    required this.jumlahBrg,
    required this.ketProduk,
    required this.unit,
    required this.status,
  });

  factory SjTagihModel.fromJson(Map<String, dynamic> json) {
    return SjTagihModel(
      no: json['no']?.toString() ?? '',
      noSj: json['NoSj']?.toString() ?? '',
      noOrder: json['NoOrder']?.toString() ?? '',
      tanggal: DateTime.parse(json['Tanggal']),
      customer: json['customer']?.toString() ?? '',
      kota: json['Kota']?.toString() ?? '',
      ekspedisi: json['Ekspedisi']?.toString() ?? '',
      keterangan: json['Keterangan']?.toString() ?? '',
      produk: json['Produk']?.toString() ?? '',
      jumlahBrg: json['jumlahbrg']?.toString() ?? '', // ✅ FIX UTAMA
      ketProduk: json['KetProduk']?.toString() ?? '',
      unit: json['Unit']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
    );
  }
}
