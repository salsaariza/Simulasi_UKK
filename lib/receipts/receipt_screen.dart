import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';

class LaporanPenjualanScreen extends StatefulWidget {
  const LaporanPenjualanScreen({super.key});

  @override
  State<LaporanPenjualanScreen> createState() => _LaporanPenjualanScreenState();
}

class _LaporanPenjualanScreenState extends State<LaporanPenjualanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? kategori = "Mingguan";
  DateTime? tanggalMulai;
  DateTime? tanggalAkhir;

  Future<void> pilihTanggalMulai() async {
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (hasil != null) {
      setState(() {
        tanggalMulai = hasil;
      });
    }
  }

  Future<void> pilihTanggalAkhir() async {
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: tanggalMulai ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (hasil != null) {
      setState(() {
        tanggalAkhir = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SidebarWidget(),
      backgroundColor: const Color(0xFFE4F4D5),
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(),

            // ========== BODY ==========  
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Laporan Penjualan",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(Icons.filter_alt,
                            color: Colors.green.shade800, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "Filter Laporan",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ==================
                    // CARD FILTER
                    // ==================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Dropdown kategori
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.shade400,
                                width: 1.4,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: kategori,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.green.shade700),
                                style: GoogleFonts.poppins(),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Mingguan",
                                    child: Text("Mingguan"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Bulanan",
                                    child: Text("Bulanan"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Produk",
                                    child: Text("Produk"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    kategori = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Input tanggal
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: pilihTanggalMulai,
                                  child: inputTanggal(
                                    "Tanggal Mulai",
                                    tanggalMulai,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: pilihTanggalAkhir,
                                  child: inputTanggal(
                                    "Tanggal Akhir",
                                    tanggalAkhir,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tombol Terapkan
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Logic filter laporan kamu nanti di sini
                              },
                              icon: Icon(
                                Icons.filter_list,
                                color: Colors.white,        // <-- warna icon
                                size: 20,
                              ),
                              label: Text(
                                "Terapkan Filter",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5E8E46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Hasill laporan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Hasil laporan akan muncul di sini...",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // WIDGET INPUT TANGGAL
  // ================================
  Widget inputTanggal(String label, DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green.shade400,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today,
              size: 18, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              date == null
                  ? label
                  : "${date.day}/${date.month}/${date.year}",
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: date == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
