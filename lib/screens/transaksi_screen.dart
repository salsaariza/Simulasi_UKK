import 'package:flutter/material.dart';

class TransaksiScreen extends StatelessWidget {
  const TransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Total Transaksi",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Rp 60.000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Daftar Transaksi",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 12),

            transaksiItem("Sate Ayam", "Rp 12.000"),
            transaksiItem("Sate Ikan", "Rp 11.000"),
            transaksiItem("Sate Ati", "Rp 11.000"),
            transaksiItem("Sate Usus", "Rp 11.000"),
          ],
        ),
      ),
    );
  }

  Widget transaksiItem(String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          Text(
            price,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
