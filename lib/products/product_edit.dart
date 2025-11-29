import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    nameController = TextEditingController(text: widget.product["name"]);
    priceController = TextEditingController(text: widget.product["price"]);
    stockController = TextEditingController(text: widget.product["stock"].toString());
    selectedCategory = widget.product["category"];
    selectedImage = widget.product["image"];
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

            // IMAGE PICKER
            GestureDetector(
              onTap: () {}, // Bisa ditambahkan fungsionalitas pilih gambar
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
                        child: Image.asset(selectedImage!, fit: BoxFit.cover),
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

            // DROPDOWN KATEGORI
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
                      selectedCategory.isEmpty ? "Pilih Kategori" : selectedCategory,
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
                    onChanged: (value) => setState(() => selectedCategory = value ?? ""),
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
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                    onPressed: () {
                      final updatedProduct = {
                        "name": nameController.text,
                        "price": priceController.text,
                        "stock": int.tryParse(stockController.text) ?? 0,
                        "category": selectedCategory,
                        "image": selectedImage ?? "assets/images/default.png",
                      };

                      // Tampilkan konfirmasi berhasil
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
                                Icon(Icons.check_circle, color: primaryGreen, size: 75),
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
                                    Navigator.of(context, rootNavigator: true).pop();
                                    Navigator.of(context, rootNavigator: true).pop(updatedProduct);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
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
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
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
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
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
