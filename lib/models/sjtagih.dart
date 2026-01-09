class SjTagihModel {
  final String no;
  final String noSj;
  final String noOrder;
  final DateTime tanggal;
  final String customer;
  final String kota;
  final String produk;
  final String status;

  SjTagihModel({
    required this.no,
    required this.noSj,
    required this.noOrder,
    required this.tanggal,
    required this.customer,
    required this.kota,
    required this.produk,
    required this.status,
  });

  factory SjTagihModel.fromJson(Map<String, dynamic> json) {
    return SjTagihModel(
      no: json['no'],
      noSj: json['NoSj'],
      noOrder: json['NoOrder'],
      tanggal: DateTime.parse(json['Tanggal']),
      customer: json['customer'],
      kota: json['Kota'],
      produk: json['Produk'],
      status: json['Status'],
    );
  }
}
