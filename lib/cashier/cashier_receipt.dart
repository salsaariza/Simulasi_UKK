import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:greenora_pos/screens/dashboard_screen.dart';

class ReceiptScreen extends StatefulWidget {
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

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  // UTIL PARSER
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
    final int change = widget.cashPaid - widget.total;
    final formattedDate =
        DateFormat('dd MMM yyyy, HH:mm').format(widget.date);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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

                  // INFORMASI TRANSAKSI
                  buildRow("Kode Transaksi", widget.transactionCode),
                  buildRow("Tanggal", formattedDate),
                  buildRow("Pelanggan", widget.customerName),
                  buildRow("Kasir", widget.cashierName),

                  const SizedBox(height: 10),
                  Divider(color: Colors.green.shade300, thickness: 1),
                  const SizedBox(height: 10),

                  // PRODUK
                  ...widget.cart.map((item) {
                    final name =
                        item["name"] ?? "Nama Produk Tidak Ditemukan";
                    final qty = parseQuantity(item["quantity"]);
                    final price = parsePrice(item["price"]);
                    final subtotal = price * qty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "$name x$qty",
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          Text(
                            formatter.format(subtotal),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 12),

                  // TOTAL & TUNAI
                  buildRow("Total", formatter.format(widget.total), bold: true),
                  if (widget.paymentMethod == "Tunai")
                    buildRow("Tunai", formatter.format(widget.cashPaid)),
                  if (widget.paymentMethod == "Tunai")
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

  // BUILD ROW
  Widget buildRow(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              left,
              style: GoogleFonts.poppins(
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            right,
            style: GoogleFonts.poppins(
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // BUTTON
  Widget fullButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // PRINT DIALOG
  void _showPrintDialog(BuildContext context) {
    final int change = widget.cashPaid - widget.total;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Struk Lengkap",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kode Transaksi : ${widget.transactionCode}",
                  style: GoogleFonts.poppins()),
              Text(
                "Tanggal : ${DateFormat('dd MMM yyyy, HH:mm').format(widget.date)}",
                style: GoogleFonts.poppins(),
              ),
              Text("Pelanggan : ${widget.customerName}",
                  style: GoogleFonts.poppins()),
              Text("Kasir : ${widget.cashierName}",
                  style: GoogleFonts.poppins()),
              const Divider(),

              ...widget.cart.map((item) {
                final name = item["name"];
                final qty = parseQuantity(item["quantity"]);
                final price = parsePrice(item["price"]);
                final subtotal = price * qty;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$name x$qty",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                      Text(
                        formatter.format(subtotal),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.green.shade300),
              const SizedBox(height: 10),

              _rowDetail("Total", formatter.format(widget.total)),
              if (widget.paymentMethod == "Tunai")
                _rowDetail("Tunai", formatter.format(widget.cashPaid)),
              if (widget.paymentMethod == "Tunai")
                _rowDetail("Kembali", formatter.format(change)),
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

  // ROW DETAIL UNTUK DIALOG
  Widget _rowDetail(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: GoogleFonts.poppins(fontSize: 12)),
          Text(
            right,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
