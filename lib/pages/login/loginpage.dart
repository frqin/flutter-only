import 'package:ekspedisi/pages/home/dashboard.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F), // warna abu gelap
      body: Column(
        children: [
          // Bagian atas (logo dan teks "Selamat Datang!")
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 120, bottom: 60),
            color: const Color(0xFF2F2F2F),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/truck.png',
                  width: 55,
                  height: 55,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'InriaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Bagian bawah (form login)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // E-mail field
                    const Text(
                      'E-mail',
                      style: TextStyle(
                        fontFamily: 'InriaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'InriaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Login
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F2F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          ); // aksi login nanti di sini
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'InriaSans',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
