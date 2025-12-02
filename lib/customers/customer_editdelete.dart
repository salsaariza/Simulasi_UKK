import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CustomerAction {
  // ============================================================
  // KONFIRMASI DELETE
  // ============================================================
  static Future<bool> confirmDelete(BuildContext context) async {
    bool result = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hapus Pelanggan?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Apakah kamu yakin ingin menghapus pelanggan ini?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  // BUTTON Aksi
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
                            onPressed: () {
                              result = false;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Batal",
                              style: GoogleFonts.poppins(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () {
                              result = true;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Hapus",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return result;
  }

  // ============================================================
  // VALIDATOR CUSTOMER
  // ============================================================
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
    if (value.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'Alamat wajib diisi';
    final trimmed = value.trim();
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(trimmed);
    if (!hasLetter) return 'Alamat wajib diisi dengan huruf';
    final validPattern = RegExp(r'^[-a-zA-Z0-9\s.,]+$');
    if (!validPattern.hasMatch(trimmed)) {
      return 'Alamat hanya boleh boleh huruf, angka opsional';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor HP wajib diisi';
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value.trim())) return 'Nomor HP hanya boleh angka';
    if (value.trim().length < 11) return 'Nomor HP terlalu pendek';
    if (value.trim().length > 13) return 'Nomor HP terlalu panjang';
    return null;
  }

  // ============================================================
  // EDIT CUSTOMER (Dialog + Supabase + Validator)
  // ============================================================
  static void editCustomer(
    BuildContext context,
    Map<String, dynamic> customer,
    Function() onUpdated, // callback refresh
  ) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController(text: customer['nama']);
    TextEditingController address =
        TextEditingController(text: customer['alamat'] ?? '');
    TextEditingController phone =
        TextEditingController(text: customer['no_hp'] ?? '');

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
                      "Edit Pelanggan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Nama
                    TextFormField(
                      controller: name,
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
                      controller: address,
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
                      controller: phone,
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
                              child: Text("Batal", style: GoogleFonts.poppins()),
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
                                  // UPDATE SUPABASE
                                  await supabase.from('pelanggan').update({
                                    'nama': name.text.trim(),
                                    'alamat': address.text.trim(),
                                    'no_hp': phone.text.trim(),
                                  }).eq('id', customer['id']);

                                  Navigator.pop(context);
                                  onUpdated(); // refresh list
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
  // DELETE CUSTOMER (Supabase)
  // ============================================================
  static Future<void> deleteCustomer(
    Map<String, dynamic> customer,
    Function() onDeleted,
  ) async {
    await supabase.from('pelanggan').delete().eq('id', customer['id']);
    onDeleted();
  }
}
