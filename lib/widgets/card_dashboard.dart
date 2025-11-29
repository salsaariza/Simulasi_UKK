import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF558B2F), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF424242),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF424242), fontSize: 11),
          ),
          Row(
            children: const [
              Expanded(
                  child: StatCard(value: "15", label: "Transaksi\nTerbaru")),
              SizedBox(width: 10),
              Expanded(
                  child: StatCard(value: "40", label: "Total Stok\nProduk")),
              SizedBox(width: 10),
              Expanded(child: StatCard(value: "2", label: "Pelanggan\nAktif")),
            ],
          ),
        ],
      ),
    );
  }
}
