import 'package:ekspedisi/models/ScrapItem.dart';
import 'package:flutter/material.dart';
import 'package:ekspedisi/pages/ekspedisi/add_scrap.dart';

class ScrapPage extends StatefulWidget {
  const ScrapPage({super.key});

  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage>
    with SingleTickerProviderStateMixin {
  final List<ScrapItem> _items = List.generate(
    3,
    (i) => ScrapItem(
      nomorPab: 'PAB-00${i + 1}',
      tanggalPab: DateTime.now().subtract(Duration(days: i * 2)),
      nomor: 'SCR-${100 + i}',
      tanggal: DateTime.now().subtract(Duration(days: i)),
      kodeBarang: 'BRG-0${i + 1}',
      namaBarang: 'Barang Sample ${i + 1}',
      satuan: 'pcs',
      jumlah: (i + 1) * 10,
      nilai: (i + 1) * 100000,
    ),
  );

  String _selectedMonth = _months[DateTime.now().month - 1];
  String _selectedYear = DateTime.now().year.toString();
  final TextEditingController _searchCtr = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchCtr.dispose();
    super.dispose();
  }

  List<ScrapItem> get _filtered {
    final q = _searchCtr.text.trim().toLowerCase();
    final monthIndex = _months.indexOf(_selectedMonth) + 1;
    final year = int.tryParse(_selectedYear) ?? DateTime.now().year;

    return _items.where((it) {
      final matchesMonth =
          it.tanggal.month == monthIndex && it.tanggal.year == year;
      final matchesQuery =
          q.isEmpty ||
          it.nomorPab.toLowerCase().contains(q) ||
          it.kodeBarang.toLowerCase().contains(q) ||
          it.namaBarang.toLowerCase().contains(q) ||
          it.nomor.toLowerCase().contains(q);
      return matchesMonth && matchesQuery;
    }).toList();
  }

  void _goToAdd() async {
    final newItem = await Navigator.push<ScrapItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddScrapPage()),
    );

    if (newItem != null) {
      setState(() => _items.insert(0, newItem));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Scrap berhasil ditambahkan'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _deleteItem(ScrapItem it) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Hapus Scrap'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${it.nomor} - ${it.namaBarang}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _items.remove(it));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Scrap berhasil dihapus'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Scrap',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'InriaSans',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                  Colors.grey.shade300,
                ],
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(filtered.length),
                  const SizedBox(height: 16),
                  _buildFilterCard(),
                  Expanded(child: _emptyState()),
                ],
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(filtered.length),
                const SizedBox(height: 16),
                _buildFilterCard(),
                const SizedBox(height: 16),
                ...List.generate(
                  filtered.length,
                  (i) => Padding(
                    padding: EdgeInsets.only(
                      bottom: i == filtered.length - 1 ? 80 : 12,
                    ),
                    child: _scrapCard(filtered[i], i),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Scrap'),
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ---------------------- UI PARTS ----------------------

  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2F2F2F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF2F2F2F),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Scrap',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '$count Item',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                  color: Color(0xFF2F2F2F),
                ),
                SizedBox(width: 8),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _monthDropdown()),
                const SizedBox(width: 12),
                Expanded(child: _yearDropdown()),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtr,
              decoration: InputDecoration(
                hintText: 'Cari nomor / kode / nama barang',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF2F2F2F),
                ),
                suffixIcon: _searchCtr.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtr.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2F2F2F),
                    width: 2,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedMonth,
        items: _months
            .map(
              (m) => DropdownMenuItem(
                value: m,
                child: Text(m, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _selectedMonth = v!),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2F2F2F), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _yearDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedYear,
        items: _years
            .map(
              (y) => DropdownMenuItem(
                value: y.toString(),
                child: Text("$y", style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _selectedYear = v!),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2F2F2F), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tidak ada data scrap',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Silakan tambah scrap baru',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _scrapCard(ScrapItem it, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2F2F2F),
                      const Color(0xFF2F2F2F).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.article_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          it.nomorPab,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _fmtDate(it.tanggalPab),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scrap number
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F2F2F).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            it.nomor,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F2F2F),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _fmtDate(it.tanggal),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Divider
                    Container(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 12),

                    // Item info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.inventory_2,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                it.kodeBarang,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                it.namaBarang,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quantity and value
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${it.jumlah} ${it.satuan}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 18,
                                color: const Color.fromARGB(255, 106, 106, 106),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rp ${_formatNumber(it.nilai)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: const Color.fromARGB(255, 65, 65, 65),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _actionButton(
                          icon: Icons.visibility_outlined,
                          label: 'Detail',
                          color: const Color.fromARGB(255, 0, 0, 0),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        _actionButton(
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                          color: const Color.fromARGB(255, 0, 0, 0),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        _actionButton(
                          icon: Icons.delete_outline,
                          label: 'Hapus',
                          color: const Color.fromARGB(255, 0, 0, 0),
                          onPressed: () => _deleteItem(it),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatNumber(int n) {
    final s = n.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
    return s;
  }
}

const List<String> _months = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

final List<int> _years = List.generate(9, (i) => DateTime.now().year - 5 + i);
