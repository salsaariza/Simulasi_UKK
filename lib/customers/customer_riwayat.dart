import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';

class RiwayatCustomerScreen extends StatelessWidget {
  final String customerName;

  const RiwayatCustomerScreen({
    super.key,
    required this.customerName,
  });

  final Color primaryGreen = const Color(0xFF4C8A2B);
  final Color lightGreenBg = const Color(0xFFE7F6D3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreenBg,
      endDrawer: const SidebarWidget(),

      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Riwayat Pembelian",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      "$customerName - 2 Transaksi",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==== CARD 1 ====
                    _riwayatCard(
                      invoice: "1245",
                      date: "07.15 15 Oktober 2025",
                      items: [
                        {"name": "Jus Alpukat", "qty": "1 x 15.000", "price": "15.000"},
                        {"name": "Jus Jambu", "qty": "1 x 10.000", "price": "10.000"},
                      ],
                      total: "25.000",
                    ),

                    const SizedBox(height: 16),

                    // ==== CARD 2 ====
                    _riwayatCard(
                      invoice: "1219",
                      date: "11.20 10 Oktober 2025",
                      items: [
                        {"name": "Ayam Panggang", "qty": "1 x 20.000", "price": "20.000"},
                        {"name": "Jus Jambu", "qty": "1 x 10.000", "price": "10.000"},
                      ],
                      total: "30.000",
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // BACK 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, bottom: 20),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        "Kembali",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== CARD WIDGET ======
  Widget _riwayatCard({
    required String invoice,
    required String date,
    required List<Map<String, String>> items,
    required String total,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryGreen, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // INVOICE & DATE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoice,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                date,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // LIST ITEM
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["name"]!,
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(item["qty"]!,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                    Text(item["price"]!,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }).toList(),
          ),

          // GARIS PEMBATAS
          Container(
            height: 1,
            color: primaryGreen,
            margin: const EdgeInsets.symmetric(vertical: 6),
          ),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Text(total,
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
