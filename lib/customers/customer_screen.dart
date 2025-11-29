import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/customers/customer_riwayat.dart';
import 'package:greenora_pos/customers/customer_editdelete.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final Color primaryGreen = const Color(0xFF4C8A2B);
  final Color lightGreenBg = const Color(0xFFE7F6D3);

  final List<Map<String, String>> customers = [
    {
      "name": "Ajeng Chalista",
      "address": "Arjowinangun",
      "phone": "0828 5445 1177",
      "initial": "A",
    },
    {
      "name": "Azura Selly",
      "address": "Sambigede",
      "phone": "0828 5445 1177",
      "initial": "A",
    },
    {
      "name": "Richo Fer",
      "address": "Karangkates",
      "phone": "0828 5445 1177",
      "initial": "R",
    },
  ];

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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manajemen Pelanggan",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= BUTTON TAMBAH =================
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryGreen,
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt,
                                size: 18, color: primaryGreen),
                            const SizedBox(width: 6),
                            Text(
                              "Tambah Pelanggan",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= SEARCH BAR =================
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryGreen,
                          width: 1.4,
                        ),
                      ),
                      height: 46,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Cari Nama",
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.search, color: primaryGreen),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= LIST CUSTOMER =================
                    Column(
                      children: customers.map((c) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ================= AVATAR =================
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Text(
                                  c["initial"]!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: primaryGreen,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // ================= CUSTOMER INFO =================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c["name"]!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.white, size: 15),
                                        const SizedBox(width: 4),
                                        Text(
                                          c["address"]!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            color: Colors.white, size: 15),
                                        const SizedBox(width: 4),
                                        Text(
                                          c["phone"]!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // ================= BUTTON RIWAYAT =================
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                RiwayatCustomerScreen(
                                                    customerName: c["name"]!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFEFEF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: primaryGreen,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Text(
                                          "Riwayat",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: primaryGreen,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ================= ACTION BUTTONS =================
                              Column(
                                children: [
                                  // EDIT
                                  GestureDetector(
                                    onTap: () {
                                      CustomerAction.editCustomer(
                                        context,
                                        c["name"]!,
                                        c["address"]!,
                                        c["phone"]!,
                                        (newName, newAddress, newPhone) {
                                          setState(() {
                                            c["name"] = newName;
                                            c["address"] = newAddress;
                                            c["phone"] = newPhone;
                                          });
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 22),
                                  ),

                                  const SizedBox(height: 14),

                                  // DELETE
                                  GestureDetector(
                                    onTap: () async {
                                      bool confirm =
                                          await CustomerAction.confirmDelete(
                                              context);

                                      if (confirm) {
                                        setState(() {
                                          customers.remove(c);
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.delete,
                                        color: Colors.white, size: 22),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
