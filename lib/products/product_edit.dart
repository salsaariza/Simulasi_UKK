import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductEdit extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductEdit({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late String selectedCategory;
  late String? selectedImage;

  final Color primaryGreen = const Color(0xFF558B2F);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product["nama_produk"]);
    priceController = TextEditingController(text: widget.product["harga"].toString());
    stockController = TextEditingController(text: widget.product["stok"].toString());
    selectedCategory = widget.product["kategori"] ?? "";
    selectedImage = widget.product["gambar"];
  }

  Future<void> updateProduct() async {
    final supabase = Supabase.instance.client;

    final int id = widget.product["id"];

    final String nama = nameController.text.trim();
    final double harga = double.tryParse(priceController.text) ?? 0.0;
    final int stok = int.tryParse(stockController.text) ?? 0;
    final String kategori = selectedCategory;
    final String gambar = selectedImage ??
        "https://i.ibb.co/02msh9G/noimage.png";

    await supabase
        .from('produk')
        .update({
          "nama_produk": nama,
          "harga": harga,
          "stok": stok,
          "kategori": kategori,
          "gambar": gambar,
          "updated_at": DateTime.now().toIso8601String()
        })
        .eq("id", id);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit Produk",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryGreen, width: 2),
                  color: Colors.white,
                ),
                child: selectedImage == null
                    ? Center(
                        child: Text(
                          "Tambahkan Gambar",
                          style: GoogleFonts.poppins(color: primaryGreen),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(selectedImage!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 18),

            _inputField("Nama Produk", nameController),
            const SizedBox(height: 12),
            _inputField("Harga Produk", priceController),
            const SizedBox(height: 12),
            _inputField("Stok", stockController),
            const SizedBox(height: 12),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedCategory.isEmpty
                          ? "Pilih Kategori"
                          : selectedCategory,
                      style: GoogleFonts.poppins(
                        color: selectedCategory.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    items: const [
                      DropdownMenuItem(value: "Minuman", child: Text("Minuman")),
                      DropdownMenuItem(value: "Makanan", child: Text("Makanan")),
                    ],
                    onChanged: (value) {
                      setState(() => selectedCategory = value ?? "");
                    },
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen),
                    onPressed: () async {

                      await updateProduct();

                      // popup sukses
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            width: 290,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    color: primaryGreen, size: 75),
                                const SizedBox(height: 10),
                                Text(
                                  "Produk berhasil diperbarui",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);  // tutup popup sukses
                                    Navigator.pop(context, true); // kirim sinyal ke ProductScreen
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 45, vertical: 12),
                                  ),
                                  child: Text(
                                    "OK",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Simpan",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryGreen),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
