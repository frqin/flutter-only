import 'package:ekspedisi/pages/ekspedisi/invoice_ekspor.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_tagih.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_umum.dart';
import 'package:ekspedisi/pages/ekspedisi/scrap.dart';
import 'package:ekspedisi/pages/login/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// 🔥 TAMBAHAN
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 INIT FIREBASE (WAJIB)
  await Firebase.initializeApp();

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
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
        '/sj-umum': (context) => const SJUmumSimplePage(),
        '/scrap': (context) => const ScrapPage(),
        '/sj-tagih': (context) => const SJTagihListPage(),
        '/invoice-export': (context) => InvoicePage(),
      },
    );
  }
}
