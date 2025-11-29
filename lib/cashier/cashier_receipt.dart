import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:greenora_pos/screens/dashboard_screen.dart';

class ReceiptScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final String customerName;
  final String cashierName;
  final String paymentMethod;
  final int total;
  final int cashPaid;
  final String transactionCode;
  final DateTime date;

  const ReceiptScreen({
    super.key,
    required this.cart,
    required this.customerName,
    required this.cashierName,
    required this.paymentMethod,
    required this.total,
    required this.cashPaid,
    required this.transactionCode,
    required this.date,
  });

  int parsePrice(dynamic price) {
    if (price is int) return price;
    if (price is double) return price.toInt();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

  int parseQuantity(dynamic qty) {
    if (qty is int) return qty;
    if (qty is double) return qty.toInt();
    if (qty is String) return int.tryParse(qty) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final int change = cashPaid - total;
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        body: Center(
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Greenora",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ruko Avenue Kav 8, Kota Malang",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // INFO TRANSAKSI
                  buildRow("Kode Transaksi", transactionCode),
                  buildRow("Tanggal", formattedDate),
                  buildRow("Pelanggan", customerName),
                  buildRow("Kasir", cashierName),
                  const SizedBox(height: 10),
                  Divider(color: Colors.green.shade300, thickness: 1),
                  const SizedBox(height: 10),

                  // DAFTAR PRODUK
                  ...cart.map((item) {
                    final name = item["name"] ?? "Nama Produk Tidak Ditemukan";
                    final qty = parseQuantity(item["quantity"]);
                    final price = parsePrice(item["price"]);
                    final subtotal = price * qty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text("$name x$qty",
                                  style: GoogleFonts.poppins(fontSize: 13))),
                          Text(formatter.format(subtotal),
                              style: GoogleFonts.poppins(fontSize: 13)),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 12),

                  // TOTAL & TUNAI
                  buildRow("Total", formatter.format(total), bold: true),
                  if (paymentMethod == "Tunai")
                    buildRow("Tunai", formatter.format(cashPaid)),
                  if (paymentMethod == "Tunai")
                    buildRow("Kembali", formatter.format(change)),

                  const SizedBox(height: 25),

                  // BUTTONS
                  fullButton(context, "Cetak Struk"),
                  const SizedBox(height: 10),
                  fullButton(context, "Tutup"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(left,
                style: GoogleFonts.poppins(
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
          ),
          Text(right,
              style: GoogleFonts.poppins(
                  fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }

  Widget fullButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (text == "Tutup") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
            );
          } else if (text == "Cetak Struk") {
            _showPrintDialog(context);
          }
        },
        child: Text(text,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    final int change = cashPaid - total;
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Struk Lengkap",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kode Transaksi : $transactionCode",
                  style: GoogleFonts.poppins()),
              Text("Tanggal : ${DateFormat('dd MMM yyyy, HH:mm').format(date)}",
                  style: GoogleFonts.poppins()),
              Text("Pelanggan : $customerName", style: GoogleFonts.poppins()),
              Text("Kasir : $cashierName", style: GoogleFonts.poppins()),
              const Divider(),
              ...cart.map((item) {
                final name = item["name"] ?? "Nama Produk Tidak Ditemukan";
                final qty = parseQuantity(item["quantity"]);
                final price = parsePrice(item["price"]);
                final subtotal = price * qty;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                              "$name - $qty x ${formatter.format(price)}",
                              style: GoogleFonts.poppins(fontSize: 13))),
                      Text(formatter.format(subtotal),
                          style: GoogleFonts.poppins(fontSize: 13)),
                    ],
                  ),
                );
              }).toList(),
              const Divider(),
              Text("Total : ${formatter.format(total)}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              if (paymentMethod == "Tunai")
                Text("Tunai : ${formatter.format(cashPaid)}",
                    style: GoogleFonts.poppins()),
              if (paymentMethod == "Tunai")
                Text("Kembali : ${formatter.format(change)}",
                    style: GoogleFonts.poppins()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            },
            child: Text("Tutup", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
