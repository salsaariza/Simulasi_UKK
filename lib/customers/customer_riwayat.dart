import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final supabase = Supabase.instance.client;

class RiwayatCustomerScreen extends StatefulWidget {
  final String customerName;
  final int customerId;

  const RiwayatCustomerScreen({
    super.key,
    required this.customerName,
    required this.customerId,
  });

  @override
  State<RiwayatCustomerScreen> createState() => _RiwayatCustomerScreenState();
}

class _RiwayatCustomerScreenState extends State<RiwayatCustomerScreen> {
  final Color primaryGreen = const Color(0xFF4C8A2B);
  final Color lightGreenBg = const Color(0xFFE7F6D3);

  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => isLoading = true);

    try {
      final penjualanData = await supabase
          .from('penjualan')
          .select('''
            id,
            no_order,
            updated_at,
            total_setelah_diskon,
            penjualan_detail (produk_nama, qty, harga)
          ''')
          .eq('pelanggan_id', widget.customerId)
          .order('updated_at', ascending: false);

      List<Map<String, dynamic>> trxList = [];

      for (var trx in penjualanData) {

        // --- Handle penjualan_detail yang NULL
        final details = trx['penjualan_detail'] ?? [];

        // --- Format tanggal agar lebih rapi
        String formattedDate = "-";
        try {
          final dateTime = DateTime.parse(trx['updated_at']);
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        } catch (_) {}

        trxList.add({
          'id': trx['id'],
          'invoice': trx['no_order'] ?? 'TRX-${trx['id']}',
          'date': formattedDate,
          'items': List<Map<String, String>>.from(
            details.map((d) => {
                  'name': d['produk_nama'] ?? '',
                  'qty': '${d['qty'] ?? 0} x ${d['harga'] ?? 0}',
                  'price': d['harga']?.toString() ?? '0',
                }),
          ),
          'total': trx['total_setelah_diskon']?.toString() ?? '0',
        });
      }

      setState(() {
        transactions = trxList;
        isLoading = false;
      });

    } catch (e) {
      print('ERROR RIWAYAT: $e');
      setState(() => isLoading = false);
    }
  }

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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())

                  // --- Jika transaksi kosong
                  : transactions.isEmpty
                      ? Center(
                          child: Text(
                            "Belum ada transaksi",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        )

                      // --- Jika ada transaksi
                      : SingleChildScrollView(
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
                                "${widget.customerName} - ${transactions.length} Transaksi",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 20),

                              ...transactions.map((trx) => Column(
                                    children: [
                                      _riwayatCard(
                                        invoice: trx['invoice'],
                                        date: trx['date'],
                                        items: List<Map<String, String>>.from(
                                            trx['items']),
                                        total: trx['total'],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  )),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
            ),

            // --- BACK BUTTON (UI sama)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, bottom: 20),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
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

  // --- CARD UI TIDAK DIUBAH ---
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(invoice,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              Text(date,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 12),
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
          Container(
            height: 1,
            color: primaryGreen,
            margin: const EdgeInsets.symmetric(vertical: 6),
          ),
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
