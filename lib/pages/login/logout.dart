import 'package:flutter/material.dart';
import 'package:ekspedisi/pages/login/loginpage.dart';
import 'package:ekspedisi/services/auth_service.dart';

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
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color.fromARGB(255, 68, 44, 44),
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

                // =========================
                // LOGOUT RESMI (SERVICE)
                // =========================
                await AuthService().logout();

                // =========================
                // KEMBALI KE LOGIN
                // =========================
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 88, 57, 57),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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

/// =========================
/// WIDGET TOMBOL LOGOUT
/// =========================
class LogoutButton extends StatelessWidget {
  final bool showLabel;
  final IconData? customIcon;
  final Color? iconColor;
  final double? iconSize;

  const LogoutButton({
    super.key,
    this.showLabel = false,
    this.customIcon,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
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
    }

    return IconButton(
      icon: Icon(
        customIcon ?? Icons.logout_rounded,
        color: iconColor ?? Colors.white,
        size: iconSize ?? 24,
      ),
      tooltip: 'Logout',
      onPressed: () => LogoutHelper.showLogoutDialog(context),
    );
  }
}
