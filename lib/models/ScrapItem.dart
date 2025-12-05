class ScrapItem {
  final String nomorPab;
  final DateTime tanggalPab;
  final String nomor;
  final DateTime tanggal;
  final String kodeBarang;
  final String namaBarang;
  final String satuan;
  final int jumlah;
  final int nilai;
  final String? keterangan;

  ScrapItem({
    required this.nomorPab,
    required this.tanggalPab,
    required this.nomor,
    required this.tanggal,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.jumlah,
    required this.nilai,
    this.keterangan,
  });
}
