import 'package:flutter/material.dart';
import '../../widgets/summary_card.dart';
import 'transaksi_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Bagian Summary
              SummaryCard(
                title: "15",
                subtitle: "Transaksi Terbaru",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransaksiScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              const SummaryCard(
                title: "40",
                subtitle: "Total Stok Produk",
              ),
              const SizedBox(height: 12),

              const SummaryCard(
                title: "2",
                subtitle: "Pelanggan Aktif",
              ),

              const SizedBox(height: 20),

              const Text(
                "Riwayat Transaksi Terbaru",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 15),

              // Contoh List Item
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Sate Ayam + Es",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      "Rp 17.000",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
