import 'package:flutter/material.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> transactions = const [
    {"time": "07.15", "date": "15 Oktober 2025", "amount": "55.000", "type": "Tunai"},
    {"time": "07.20", "date": "15 Oktober 2025", "amount": "90.000", "type": "Tunai"},
    {"time": "07.38", "date": "15 Oktober 2025", "amount": "20.000", "type": "Tunai"},
    {"time": "08.02", "date": "15 Oktober 2025", "amount": "44.000", "type": "Tunai"},
    {"time": "08.15", "date": "15 Oktober 2025", "amount": "225.000", "type": "Tunai"},
    {"time": "09.02", "date": "15 Oktober 2025", "amount": "54.000", "type": "Tunai"},
    {"time": "09.30", "date": "15 Oktober 2025", "amount": "32.000", "type": "Tunai"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEFD6),
      endDrawer: const SidebarWidget(),
      body: Column(
        children: [
          const DashboardHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Text(
                    "Dashboard",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(child: _buildStatCard("15", "Transaksi\nTerbaru", () {})),
                      const SizedBox(width: 10),
                      Expanded(child: _buildStatCard("125", "Total\nStok", () {})),
                      const SizedBox(width: 10),
                      Expanded(child: _buildStatCard("2", "Pelanggan\nAktif", () {})),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF558B2F), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          "2.360.000",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Penjualan Hari Ini",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  _buildChartSection(
                    titleLeftActive: true,
                    bars: const [0.2, 0.45, 0.30, 0.70, 0.28, 0.55, 0.48, 0.85, 0.75],
                    labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep'],
                  ),
                  const SizedBox(height: 22),

                  _buildLineChart(),
                  const SizedBox(height: 22),

                  Text(
                    "Daftar Transaksi Terbaru",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRecentTransactionList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionList() {
    return Column(
      children: transactions.map((t) => _buildTransactionItem(t)).toList(),
    );
  }

  Widget _buildTransactionItem(Map<String, String> transaction) {
    const Color kPrimaryGreen = Color(0xFF558B2F);
    const Color kLightBorderColor = Color(0xFFBCE0AA);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kLightBorderColor, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: kPrimaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaksi Pembayaran',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF424242)),
                ),
                Text(
                  '${transaction['time']} ${transaction['date']}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp. ${transaction['amount']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF424242)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  transaction['type'] ?? 'Cash',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildStatCard(String value, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              style: GoogleFonts.poppins(color: const Color(0xFF424242), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: const Color(0xFF424242), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF558B2F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF558B2F)),
        boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)] : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: active ? Colors.white : const Color(0xFF558B2F),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChartSection({required bool titleLeftActive, required List<double> bars, required List<String> labels}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF558B2F))),
      child: Column(
        children: [
          Row(children: [_tabButton("Mingguan", titleLeftActive), const SizedBox(width: 10), _tabButton("Bulanan", !titleLeftActive)]),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceAround, children: bars.map((h) => _buildBar(h)).toList()),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: labels.map((t) => Text(t, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey))).toList()),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor) {
    return Container(width: 14, height: 150 * heightFactor, decoration: BoxDecoration(color: const Color(0xFF616161), borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF558B2F))),
      child: Column(
        children: [
          Row(children: [_tabButton("Mingguan", false), const SizedBox(width: 10), _tabButton("Bulanan", true)]),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                12,
                (i) => Container(width: 10, height: 150 * (0.3 + (i * 0.05)), decoration: BoxDecoration(color: const Color(0xFF8BC34A), borderRadius: BorderRadius.circular(4))),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text("2025", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
