import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/cashier/cashier_screen.dart';
import 'package:greenora_pos/cashier/cashier_receipt.dart';

class DetailCashierScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final void Function(bool) onConfirm;

  const DetailCashierScreen({
    super.key,
    required this.cart,
    required this.onConfirm,
  });

  @override
  State<DetailCashierScreen> createState() => _DetailCashierScreenState();
}

class _DetailCashierScreenState extends State<DetailCashierScreen> {
  int selectedPayment = 1; // 1 = Tunai, 2 = Kartu
  TextEditingController discountController = TextEditingController(text: "0");

  TextEditingController cashController = TextEditingController();
  int cashPaid = 0;

  TextEditingController customerController = TextEditingController();
  List<String> customers = ["Ajeng Chalista", "Budi Santoso", "Citra Lestari"];
  List<String> filteredCustomers = [];

  final Color lightGreenBg = const Color(0xFFDCEFD6);

  @override
  void initState() {
    super.initState();
    filteredCustomers = customers;
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.cart.fold<int>(0, (sum, item) {
      int price = int.tryParse(item["price"].replaceAll('.', '')) ?? 0;
      int qty = (item["quantity"] as num).toInt();
      return sum + (price * qty);
    });

    int discountAmount = int.tryParse(discountController.text) ?? 0;
    int finalTotal = total - discountAmount;
    int change = cashPaid - finalTotal;

    return Scaffold(
      backgroundColor: lightGreenBg,
      endDrawer: SidebarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER MEPET ATAS
              const DashboardHeader(),
              const SizedBox(height: 16),

              // TITLE + ICON PLUS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Kasir",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: const Color(0xFF4C8C42),
                      onPressed: () async {
                        final newProducts = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CashierScreen(),
                          ),
                        );

                        if (newProducts != null &&
                            newProducts is List<Map<String, dynamic>>) {
                          setState(() {
                            for (var newItem in newProducts) {
                              int index = widget.cart.indexWhere(
                                  (item) => item["name"] == newItem["name"]);
                              if (index != -1) {
                                widget.cart[index]["quantity"] +=
                                    newItem["quantity"];
                              } else {
                                widget.cart
                                    .add(Map<String, dynamic>.from(newItem));
                              }
                            }
                          });
                        }
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // SEARCH PELANGGAN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: customerController,
                  decoration: InputDecoration(
                    hintText: "Cari pelanggan...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green.shade300),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (val) {
                    setState(() {
                      filteredCustomers = customers
                          .where((c) =>
                              c.toLowerCase().contains(val.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              if (customerController.text.isNotEmpty &&
                  filteredCustomers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredCustomers[index]),
                          onTap: () {
                            setState(() {
                              customerController.text =
                                  filteredCustomers[index];
                              filteredCustomers = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // KERANJANG
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Keranjang (${widget.cart.length} item)",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: widget.cart.map((product) {
                    int price =
                        int.tryParse(product["price"].replaceAll('.', '')) ?? 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["name"],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rp. ${product["price"]}/item",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _qtyButton(Icons.remove, () {
                                setState(() {
                                  if (product["quantity"] > 1) {
                                    product["quantity"]--;
                                  } else {
                                    widget.cart.remove(product);
                                  }
                                });
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "${product["quantity"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _qtyButton(Icons.add, () {
                                setState(() {
                                  product["quantity"]++;
                                });
                              }),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Subtotal : ${price * product["quantity"]}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDiskonSection(total),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPaymentSection(),
              ),
              const SizedBox(height: 16),

              if (selectedPayment == 1) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Tunai",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: TextField(
                      controller: cashController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          cashPaid = int.tryParse(val) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan jumlah tunai",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "Kembalian",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        change < 0 ? "0" : "$change",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmDialog(context, finalTotal);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF4C8C42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Konfirmasi Pembayaran",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }

  Widget _buildDiskonSection(int subtotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Total", style: GoogleFonts.poppins(fontSize: 13)),
              const Spacer(),
              Text("$subtotal",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text("Diskon", style: GoogleFonts.poppins(fontSize: 14)),
              const Spacer(),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Rp 0",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text("Total Bayar", style: GoogleFonts.poppins(fontSize: 14)),
              const Spacer(),
              Text(
                "${subtotal - (int.tryParse(discountController.text) ?? 0)}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Metode Pembayaran",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _paymentButton("Tunai", 1, Icons.credit_card),
            const SizedBox(width: 12),
            _paymentButton("Kartu", 2, Icons.payment),
          ],
        )
      ],
    );
  }

  Widget _paymentButton(String label, int id, IconData icon) {
    bool active = selectedPayment == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedPayment = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF4C8C42) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: active ? Colors.transparent : Colors.grey.shade400),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: active ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: active ? Colors.white : Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, int finalTotal) {
    int change = cashPaid - finalTotal;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Konfirmasi Transaksi",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _rowDetail(
                  "Pelanggan",
                  customerController.text.isEmpty
                      ? "-"
                      : customerController.text,
                ),
                _rowDetail("Item", "${widget.cart.length} Produk"),
                const SizedBox(height: 10),
                Text(
                  "Detail Produk:",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ...widget.cart.map((item) {
                  int price =
                      int.tryParse(item["price"].replaceAll('.', '')) ?? 0;
                  int qty = (item["quantity"] as num).toInt();
                  int subtotal = price * qty;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${item["name"]} x$qty",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                        Text(
                          "$subtotal",
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
                _rowDetail("Total", "$finalTotal"),
                if (selectedPayment == 1) _rowDetail("Tunai", "$cashPaid"),
                if (selectedPayment == 1)
                  _rowDetail("Kembali", change < 0 ? "0" : "$change"),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFE8F6E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Batal",
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF4C8C42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onConfirm(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReceiptScreen(
                                cart: widget.cart
                                    .map((item) => {
                                          "name":
                                              item["name"], // HARUS pasti ada
                                          "price": int.tryParse(item["price"]
                                                  .toString()
                                                  .replaceAll('.', '')) ??
                                              0,
                                          "quantity":
                                              (item["quantity"] as num).toInt(),
                                        })
                                    .toList(),
                                customerName: customerController.text,
                                cashierName: "Riri",
                                paymentMethod:
                                    selectedPayment == 1 ? "Tunai" : "Kartu",
                                total: finalTotal,
                                cashPaid: cashPaid,
                                transactionCode:
                                    "TRX-${DateTime.now().millisecondsSinceEpoch}",
                                date: DateTime.now(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Konfirmasi",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
