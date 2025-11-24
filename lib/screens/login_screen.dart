import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_green.png',
                  width: 120,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aplikasi Sistem Penjualan Makanan',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF4E7C4A),
                  ),
                ),
                const SizedBox(height: 50),

                // Username
                TextField(
                  controller: _usernameController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Berhasil')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
