import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'error_screen.dart';
import '../services/supabase_client.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 1));

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // Tampilkan ErrorScreen jika tidak ada internet
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorScreen(
            errorType: ErrorType.noInternet,
            message: "Tidak ada koneksi internet!",
            onRetry: _initApp,
          ),
        ),
      );
      return;
    }

    // Inisialisasi Supabase hanya jika internet ada
    await SupabaseConfig.init();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
