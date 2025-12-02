import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/customers/customer_riwayat.dart';
import 'package:greenora_pos/customers/customer_editdelete.dart';

final supabase = Supabase.instance.client;

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final Color primaryGreen = const Color(0xFF4C8A2B);
  final Color lightGreenBg = const Color(0xFFE7F6D3);

  List<Map<String, dynamic>> customers = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  // ============================================================
  // FETCH DATA PELANGGAN DARI SUPABASE
  // ============================================================
  Future<void> fetchCustomers() async {
    final data = await supabase
        .from('pelanggan')
        .select()
        .order('created_at', ascending: true);
    setState(() {
      customers = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  // ============================================================
// VALIDATOR CUSTOMER
// ============================================================

// Nama harus huruf + spasi
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama pelanggan wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Nama hanya boleh huruf dan spasi';
    }
    return null;
  }

// Alamat harus huruf + angka + karakter umum alamat
  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat wajib diisi';
    }
    // huruf, angka, spasi, koma, titik, strip
    if (!RegExp(r'^[-a-zA-Z0-9\s.,]+$').hasMatch(value.trim())) {
      return 'Alamat hanya boleh boleh huruf, angka opsional';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi';
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Nomor HP hanya boleh angka';
    }
    if (value.trim().length < 11) return 'Nomor HP terlalu pendek';
    if (value.trim().length > 13) return 'Nomor HP terlalu panjang';
    return null;
  }

  // ============================================================
  // POPUP TAMBAH PELANGGAN
  // ============================================================
  void showAddCustomerDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 330,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tambah Pelanggan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Nama
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nama Pelanggan",
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: validateName,
                    ),
                    const SizedBox(height: 12),

                    // Alamat
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Alamat",
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: validateAddress,
                    ),
                    const SizedBox(height: 12),

                    // Telepon
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "No Telp.",
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: validatePhone,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Batal",
                                style:
                                    GoogleFonts.poppins(color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4C8A2B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await supabase.from('pelanggan').insert({
                                    'nama': nameController.text.trim(),
                                    'alamat': addressController.text.trim(),
                                    'no_hp': phoneController.text.trim(),
                                  });

                                  Navigator.pop(context);
                                  fetchCustomers(); // refresh data
                                  showSuccessPopup();
                                }
                              },
                              child: Text(
                                "Simpan",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // POPUP BERHASIL DITAMBAH
  // ============================================================
  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Berhasil Ditambah",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "OK",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // MAIN WIDGET
  // ============================================================
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredCustomers = customers.where((c) {
      return c["nama"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

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
                  : SingleChildScrollView(
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
                          GestureDetector(
                            onTap: showAddCustomerDialog,
                            child: Container(
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
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
                                    },
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
                            children: filteredCustomers.map((c) {
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
                                    // AVATAR
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        c["nama"]![0].toUpperCase(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: primaryGreen,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // INFO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c["nama"]!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Colors.white,
                                                  size: 15),
                                              const SizedBox(width: 4),
                                              Text(
                                                c["alamat"] ?? "",
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
                                                  color: Colors.white,
                                                  size: 15),
                                              const SizedBox(width: 4),
                                              Text(
                                                c["no_hp"] ?? "",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // RIWAYAT BUTTON
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      RiwayatCustomerScreen(
                                                    customerName: c["nama"]!,
                                                    customerId: c["id"],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
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

                                    // ACTION BUTTONS
                                    Column(
                                      children: [
                                        // EDIT BUTTON
                                        GestureDetector(
                                          onTap: () {
                                            CustomerAction.editCustomer(
                                              context,
                                              c, // kirim seluruh map customer
                                              () {
                                                fetchCustomers(); // refresh setelah update
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.edit,
                                              color: Colors.white, size: 22),
                                        ),

                                        const SizedBox(height: 14),
                                        GestureDetector(
                                          onTap: () async {
                                            bool confirm = await CustomerAction
                                                .confirmDelete(context);
                                            if (confirm) {
                                              await supabase
                                                  .from('pelanggan')
                                                  .delete()
                                                  .eq('id', c['id']);
                                              fetchCustomers();
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
}
