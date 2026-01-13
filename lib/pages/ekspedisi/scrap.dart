import 'package:ekspedisi/pages/ekspedisi/detail_scrap.dart';
import 'package:flutter/material.dart';
import 'package:ekspedisi/models/scrap.dart';
import 'package:ekspedisi/services/scrap_service.dart';

class ScrapPage extends StatefulWidget {
  const ScrapPage({super.key});

  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  List<ScrapModel> list = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await ScrapService.fetchScrap();

      setState(() {
        list = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Scrap',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2F2F2F)),
            )
          : error.isNotEmpty
          ? Center(child: Text(error))
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScrapPage(item: item),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NO SCRAP
                          Text(
                            item.no,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2F2F2F),
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// CUSTOMER
                          Text(
                            item.customer,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// EKSPEDISI
                          Text(
                            item.ekspedisi,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// STATUS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                item.status,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status.replaceAll('_', ' '),
                              style: TextStyle(
                                color: _statusColor(item.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('setuju')) {
      return Colors.green;
    }
    if (status.toLowerCase().contains('tolak')) {
      return Colors.red;
    }
    return Colors.orange;
  }
}
