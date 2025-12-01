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
  // EDIT CUSTOMER (Dialog + Supabase)
  // ============================================================
  static void editCustomer(
    BuildContext context,
    Map<String, dynamic> customer,
    Function() onUpdated, // callback refresh
  ) {
    TextEditingController name =
        TextEditingController(text: customer['nama']);
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
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Nama Pelanggan",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Alamat
                  TextField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Telepon
                  TextField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "No Telp.",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                              // UPDATE SUPABASE
                              await supabase
                                  .from('pelanggan')
                                  .update({
                                    'nama': name.text,
                                    'alamat': address.text,
                                    'no_hp': phone.text,
                                  })
                                  .eq('id', customer['id']);
                              Navigator.pop(context);
                              onUpdated(); // refresh list
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
