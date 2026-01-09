import 'package:flutter/material.dart';
import 'package:ekspedisi/models/scrap_model.dart';
import 'package:ekspedisi/services/scrap_service.dart';
import 'edit_scrap.dart';
import 'add_scrap.dart';

class ScrapPage extends StatefulWidget {
  final String token;
  const ScrapPage({super.key, required this.token});

  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  late Future<List<ScrapModel>> future;
  String searchQuery = '';
  String? selectedFilter1;
  String? selectedFilter2;

  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 1.0;
  double _headerScale = 1.0;
  double _lastOffset = 0.0;

  // TAMBAHAN: variable total scrap
  int _totalScrap = 0;

  @override
  void initState() {
    super.initState();
    future = ScrapService.fetchScrap(widget.token);

    _scrollController.addListener(() {
      final offset = _scrollController.offset;

      if ((offset - _lastOffset).abs() < 10) return;

      _lastOffset = offset;

      final newOpacity = (1.0 - (offset / 100)).clamp(0.0, 1.0);
      final newScale = (1.0 - (offset / 400)).clamp(0.8, 1.0);

      if ((_headerOpacity - newOpacity).abs() > 0.05 ||
          (_headerScale - newScale).abs() > 0.05) {
        setState(() {
          _headerOpacity = newOpacity;
          _headerScale = newScale;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<ScrapModel> _filterData(List<ScrapModel> data) {
    return data.where((item) {
      final matchesSearch =
          item.nopabean.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.kodeBarang.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  void _refreshData() {
    setState(() {
      future = ScrapService.fetchScrap(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scrap'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total scrap',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      // BAGIAN INI SEKARANG baca dari state
                      Text(
                        '$_totalScrap Item',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          FutureBuilder<List<ScrapModel>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text('Data kosong'),
                      ],
                    ),
                  ),
                );
              }

              // TAMBAHAN LOGIC UTAMA: update total scrap otomatis
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _totalScrap = snapshot.data!.length;
                    });
                  }
                });
              }

              final filteredData = _filterData(snapshot.data!);

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = filteredData[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (val) {},
                                  fillColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                  checkColor: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Barang ${item.kodeBarang}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'BARANG SAMPLE',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScrapPage(
                                          token: widget.token,
                                          scrap: item,
                                          onSaved: _refreshData,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.nopabean,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfoButton('Jumlah\n${item.jumlah}'),
                                _buildInfoButton('Nilai\n${item.nilai}'),
                                _buildInfoButton('Nomor\n${item.nomor}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: filteredData.length),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddScrapPage(token: widget.token, onSaved: _refreshData),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Scrap'),
      ),
    );
  }

  Widget _buildInfoButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
