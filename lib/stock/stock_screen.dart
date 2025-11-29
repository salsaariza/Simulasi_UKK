import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';

class StokScreen extends StatefulWidget {
  const StokScreen({super.key});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class _StokScreenState extends State<StokScreen> {
  bool showSuccessPopup = false;

  // Contoh data produk
  final List<Map<String, dynamic>> products = [
    {"name": "Jus Stroberi", "category": "Minuman", "stock": 10},
    {"name": "Jus Jambu", "category": "Minuman", "stock": 5},
    {"name": "Jus Kiwi", "category": "Minuman", "stock": 0},
    {"name": "Jus Alpukat", "category": "Minuman", "stock": 20},
  ];

  // Data riwayat stok
  final List<Map<String, dynamic>> stockHistory = [
    {
      "name": "Jus Alpukat",
      "date": "07.15 15 Oktober 2025",
      "amount": 20,
      "type": "Masuk",
      "desc": "Update dari dapur",
      "admin": "Ajeng Chailista"
    },
    {
      "name": "Jus Alpukat",
      "date": "08.15 15 Oktober 2025",
      "amount": -15,
      "type": "Keluar",
      "desc": "Penjualan",
      "admin": "Richo Vaerdian"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Hitung produk dengan stok rendah
    final lowStockCount =
        products.where((p) => p['stock'] <= 5).toList().length;

    return Scaffold(
      endDrawer: const SidebarWidget(),
      backgroundColor: const Color(0xFFDCEFD6),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const DashboardHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tampilkan banner hanya jika ada stok rendah
                        if (lowStockCount > 0) _warningBanner(lowStockCount),

                        const SizedBox(height: 10),
                        Text(
                          "Manajemen Stok",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),
                        ...products.map((p) => _productCard(p)).toList(),

                        const SizedBox(height: 30),
                        Text(
                          "Riwayat Perubahan Stok",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),
                        ...stockHistory.map((h) => _historyCard(h)).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Popup sukses muncul di tengah layar
          if (showSuccessPopup) _successPopup(),
        ],
      ),
    );
  }

  // ======================================================
  // Banner Stok Rendah
  // ======================================================
  Widget _warningBanner(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$count Produk Dengan Stok Rendah",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // UI Kartu Riwayat
  // ======================================================
  Widget _historyCard(Map<String, dynamic> data) {
    bool isMasuk = data["type"] == "Masuk";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data["name"],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isMasuk ? const Color(0xFFE6F4E7) : const Color(0xFFFFE2E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data["type"],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isMasuk ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data["date"],
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            "${data["amount"] > 0 ? "+${data["amount"]}" : data["amount"]} Stok",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data["desc"],
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            "Admin : ${data["admin"]}",
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // UI Produk
  // ======================================================
  Widget _productCard(Map<String, dynamic> p) {
    bool isLow = p['stock'] <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p["name"],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _categoryBadge(p["category"]),
              const SizedBox(width: 8),
              _stockBadge(isLow),
              const Spacer(),
              Text(
                "Stok: ${p["stock"]}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openUpdateSheet(p),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF407F38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                "Update Stok",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF407F38),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _stockBadge(bool low) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: low ? const Color(0xFFFFE2E2) : const Color(0xFFE2FFE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        low ? "Rendah" : "Normal",
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: low ? Colors.red : Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ======================================================
  // UPDATE STOK
  // ======================================================
  void _openUpdateSheet(Map<String, dynamic> product) {
    TextEditingController stockC =
        TextEditingController(text: product["stock"].toString());

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 22,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Update Stok",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: stockC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Stok",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF407F38), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      int newStock =
                          int.tryParse(stockC.text) ?? product["stock"];

                      setState(() {
                        product["stock"] = newStock;
                        showSuccessPopup = true;
                      });

                      Navigator.pop(context);

                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => showSuccessPopup = false);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF407F38),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Konfirmasi",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // POPUP SUKSES
  // ======================================================
  Widget _successPopup() {
    return Container(
      color: Colors.black38,
      alignment: Alignment.center,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 65, color: Color(0xFF407F38)),
            const SizedBox(height: 10),
            Text(
              "Berhasil Ditambahkan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => setState(() => showSuccessPopup = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF407F38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: Text(
                "OK",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
