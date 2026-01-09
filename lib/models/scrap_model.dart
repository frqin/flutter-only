class ScrapModel {
  final int id;
  final String nopabean;
  final String noseri;
  final String kodeBarang;
  final String jumlah;
  final String nilai;
  final String nomor;

  ScrapModel({
    required this.id,
    required this.nopabean,
    required this.noseri,
    required this.kodeBarang,
    required this.jumlah,
    required this.nilai,
    required this.nomor,
  });

  factory ScrapModel.fromJson(Map<String, dynamic> json) {
    return ScrapModel(
      id: json['id'] ?? 0,
      nopabean: json['nopabean'] ?? '',
      noseri: json['noseri'] ?? '',
      kodeBarang: json['KodeBarang'] ?? '', // ⬅️ HURUF BESAR K (sesuai API)
      jumlah: json['jumlah'] ?? '0',
      nilai: json['nilai'] ?? '0',
      nomor: json['nomor'] ?? '',
    );
  }

  // Tambahan: untuk debug
  @override
  String toString() {
    return 'ScrapModel(id: $id, nopabean: $nopabean, kode: $kodeBarang)';
  }
}
