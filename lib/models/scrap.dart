class ScrapModel {
  final String no;
  final String noSj;
  final String noOrder;
  final DateTime tanggal;
  final String idCustomer;
  final String keterangan;
  final String ekspedisi;
  final String status;
  final DateTime lastUpdate;
  final String userId;
  final String cek;
  final String flag;
  final String idBrg;
  final String produk;
  final String harga;
  final String jumlahBrg;
  final String totalHarga;
  final String customer;
  final String kota;
  final String ketProduk;
  final String unit;

  ScrapModel({
    required this.no,
    required this.noSj,
    required this.noOrder,
    required this.tanggal,
    required this.idCustomer,
    required this.keterangan,
    required this.ekspedisi,
    required this.status,
    required this.lastUpdate,
    required this.userId,
    required this.cek,
    required this.flag,
    required this.idBrg,
    required this.produk,
    required this.harga,
    required this.jumlahBrg,
    required this.totalHarga,
    required this.customer,
    required this.kota,
    required this.ketProduk,
    required this.unit,
  });

  factory ScrapModel.fromJson(Map<String, dynamic> json) {
    return ScrapModel(
      no: json['no'],
      noSj: json['NoSj'],
      noOrder: json['NoOrder'],
      tanggal: DateTime.parse(json['Tanggal']),
      idCustomer: json['IdCustomer'],
      keterangan: json['Keterangan'],
      ekspedisi: json['Ekspedisi'],
      status: json['Status'],
      lastUpdate: DateTime.parse(json['LastUpdate']),
      userId: json['UserId'],
      cek: json['cek'],
      flag: json['Flag'],
      idBrg: json['idbrg'],
      produk: json['Produk'],
      harga: json['Harga'],
      jumlahBrg: json['jumlahbrg'],
      totalHarga: json['totalharga'],
      customer: json['customer'],
      kota: json['Kota'],
      ketProduk: json['KetProduk'],
      unit: json['Unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "no": no,
      "NoSj": noSj,
      "NoOrder": noOrder,
      "Tanggal": tanggal.toIso8601String(),
      "IdCustomer": idCustomer,
      "Keterangan": keterangan,
      "Ekspedisi": ekspedisi,
      "Status": status,
      "LastUpdate": lastUpdate.toIso8601String(),
      "UserId": userId,
      "cek": cek,
      "Flag": flag,
      "idbrg": idBrg,
      "Produk": produk,
      "Harga": harga,
      "jumlahbrg": jumlahBrg,
      "totalharga": totalHarga,
      "customer": customer,
      "Kota": kota,
      "KetProduk": ketProduk,
      "Unit": unit,
    };
  }
}
