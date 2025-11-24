import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_green.png',
              width: 180,
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikasi Sistem Penjualan Makanan',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(225,78,124,74), 
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
