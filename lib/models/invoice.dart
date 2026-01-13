class Invoice {
  final String no;
  final String noInvoice;
  final String tanggal;
  final String mess;
  final String ship;
  final String asal;
  final String tujuan;
  final String description;
  final String orderNote;
  final String noLc;
  final String bb;
  final String bk;
  final String ukuran;
  final String tglBl;
  final String cost;
  final String biaya;
  final String biaya1;
  final String biaya2;
  final String shipper;
  final String urut;
  final String cetak;
  final String flag;
  final String status;

  final String produk;
  final String harga;
  final String jumlahBrg;
  final String totalHarga;
  final String unit;

  Invoice({
    required this.no,
    required this.noInvoice,
    required this.tanggal,
    required this.mess,
    required this.ship,
    required this.asal,
    required this.tujuan,
    required this.description,
    required this.orderNote,
    required this.noLc,
    required this.bb,
    required this.bk,
    required this.ukuran,
    required this.tglBl,
    required this.cost,
    required this.biaya,
    required this.biaya1,
    required this.biaya2,
    required this.shipper,
    required this.urut,
    required this.cetak,
    required this.flag,
    required this.status,
    required this.produk,
    required this.harga,
    required this.jumlahBrg,
    required this.totalHarga,
    required this.unit,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      no: json['no'] ?? '',
      noInvoice: json['NO_INVOICE'] ?? '',
      tanggal: json['TANGGAL'] ?? '',
      mess: json['MESS'] ?? '',
      ship: json['SHIP'] ?? '',
      asal: json['ASAL'] ?? '',
      tujuan: json['TUJUAN'] ?? '',
      description: json['DESCRIPTION'] ?? '',
      orderNote: json['ORDER_NOTE'] ?? '',
      noLc: json['NO_LC'] ?? '',
      bb: json['BB'] ?? '0.00',
      bk: json['BK'] ?? '0.00',
      ukuran: json['UKURAN'] ?? '',
      tglBl: json['TGL_BL'] ?? '',
      cost: json['COST'] ?? '',
      biaya: json['BIAYA'] ?? '',
      biaya1: json['BIAYA1'] ?? '',
      biaya2: json['BIAYA2'] ?? '0.00',
      shipper: json['SHIPPER'] ?? '',
      urut: json['URUT'] ?? '',
      cetak: json['CETAK'] ?? '',
      flag: json['FLAG'] ?? '',
      status: json['status'] ?? '',
      produk: json['Produk'] ?? '',
      harga: json['Harga'] ?? '',
      jumlahBrg: json['jumlahbrg'] ?? '',
      totalHarga: json['totalharga'] ?? '',
      unit: json['Unit'] ?? '',
    );
  }
}
