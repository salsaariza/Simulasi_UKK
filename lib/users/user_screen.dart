import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/users/succes_popup.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';

class PetugasScreen extends StatefulWidget {
  const PetugasScreen({Key? key}) : super(key: key);

  @override
  State<PetugasScreen> createState() => _PetugasScreenState();
}

class _PetugasScreenState extends State<PetugasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchQuery = "";

  List<Map<String, String>> users = [
    {"name": "Ajeng Chalista", "role": "Admin"},
    {"name": "Richo Veersdin", "role": "Petugas"},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where(
            (u) => u["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFDCEFD6),
      endDrawer: const SidebarWidget(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Petugas",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xff79A76E), width: 1.4),
                      ),
                      child: TextField(
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Cari",
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                          suffixIcon:
                              Icon(Icons.search, color: Colors.green.shade700),
                        ),
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Tambah Buttons
                    Row(
                      children: [
                        Expanded(
                          child: buildRoundedButton(
                            icon: Icons.admin_panel_settings,
                            text: "Tambah Admin",
                            onTap: () => showAddDialog("Admin"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildRoundedButton(
                            icon: Icons.person_add_alt_1,
                            text: "Tambah Petugas",
                            onTap: () => showAddDialog("Petugas"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Daftar Admin dan Petugas",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...filteredUsers.map(buildUserCard),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // POPUP ADD ADMIN / PETUGAS
  void showAddDialog(String role) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tambah $role",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                buildInput("Nama $role", nameController),
                const SizedBox(height: 14),
                buildInput("Username", usernameController),
                const SizedBox(height: 14),
                buildInput("Password", passwordController, obscure: true),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Batal
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5F2D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Batal",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Konfirmasi
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            // tambah data
                            setState(() {
                              users.add({
                                "name": nameController.text,
                                "role": role,
                              });
                            });

                            // Tutup dialog tambah
                            Navigator.pop(context);

                            // gunakan context yang aman untuk memunculkan popup
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              if (!mounted) return;

                              showSuccessDialog(
                                _scaffoldKey.currentContext ?? context,
                                "$role berhasil ditambahkan!",
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8E46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Konfirmasi",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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

  // INPUT FIELD
  Widget buildInput(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff79A76E), width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff5E8E46), width: 1.5),
        ),
      ),
    );
  }

  // TOMBOL BULAT
  Widget buildRoundedButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xff79A76E), width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD USER
  Widget buildUserCard(Map<String, String> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.22),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user["name"]!,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xff5E8E46),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user["role"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // DELETE ICON
          const Icon(Icons.delete_outline, size: 28),
        ],
      ),
    );
  }
}
