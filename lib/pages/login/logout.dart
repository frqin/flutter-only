import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekspedisi/pages/login/loginpage.dart';

class LogoutHelper {
  static Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color.fromARGB(255, 68, 44, 44),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontFamily: 'InriaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(
              fontFamily: 'InriaSans',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'InriaSans',
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Tutup dialog
                Navigator.of(dialogContext).pop();

                // Hapus data user
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigate ke login page
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 88, 57, 57),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'InriaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget untuk tombol logout yang bisa digunakan di berbagai tempat
class LogoutButton extends StatelessWidget {
  final bool showLabel;
  final IconData? customIcon;
  final Color? iconColor;
  final double? iconSize;

  const LogoutButton({
    Key? key,
    this.showLabel = false,
    this.customIcon,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      // Tombol dengan label (untuk drawer atau menu)
      return ListTile(
        leading: Icon(
          customIcon ?? Icons.logout_rounded,
          color: iconColor ?? Colors.red.shade600,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => LogoutHelper.showLogoutDialog(context),
      );
    } else {
      // Icon button saja
      return IconButton(
        icon: Icon(
          customIcon ?? Icons.logout_rounded,
          color: iconColor ?? Colors.white,
          size: iconSize ?? 24,
        ),
        onPressed: () => LogoutHelper.showLogoutDialog(context),
        tooltip: 'Logout',
      );
    }
  }
}
