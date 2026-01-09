import 'package:ekspedisi/pages/ekspedisi/invoice_ekspor.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_tagih.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_umum.dart';
import 'package:ekspedisi/pages/ekspedisi/scrap.dart';
import 'package:ekspedisi/pages/login/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N-Approval',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(),

      routes: {
        '/sj-umum': (context) => const SJUmumPage(),
        '/scrap': (context) => const ScrapPage(
          token:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwicm9sZSI6Im93bmVyIiwiaWF0IjoxNzY3NjcwNTkyLCJleHAiOjE3Njc3NTY5OTJ9.ct_gS07FyfM1kx0gBvKu08JUlioinYcms3wnB6wapzI',
        ),
        '/sj-tagih': (context) => const SJTagihPage(),
        '/invoice-export': (context) => InvoiceEksporPage(),
      },
    );
  }
}
