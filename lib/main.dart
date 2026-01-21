import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PAGES
import 'package:ekspedisi/pages/login/welcomepage.dart';
import 'package:ekspedisi/pages/home/dashboard.dart';

// ROUTES
import 'package:ekspedisi/pages/ekspedisi/invoice_ekspor.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_tagih.dart';
import 'package:ekspedisi/pages/ekspedisi/s_j_umum.dart';
import 'package:ekspedisi/pages/ekspedisi/scrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 INIT FIREBASE
  await Firebase.initializeApp();

  // 🔥 INIT LOCALE INDONESIA
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// =========================
  /// CEK SESSION LOGIN
  /// =========================
  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N-Approval',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      /// =========================
      /// AUTO LOGIN HANDLER
      /// =========================
      home: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          // Loading awal
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika sudah login → Dashboard
          if (snapshot.data == true) {
            return const DashboardPage();
          }

          // Jika belum login → Welcome
          return const WelcomePage();
        },
      ),

      /// =========================
      /// ROUTES
      /// =========================
      routes: {
        '/sj-umum': (context) => const SJUmumSimplePage(),
        '/scrap': (context) => const ScrapPage(),
        '/sj-tagih': (context) => const SJTagihListPage(),
        '/invoice-export': (context) => InvoicePage(),
      },
    );
  }
}
