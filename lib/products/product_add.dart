import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  String selectedCategory = "";
  String? selectedImage;

  final Color primaryGreen = const Color(0xFF558B2F);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tambah Produk",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 20),

            // IMAGE PICKER
            GestureDetector(
              onTap: _selectImageDialog,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryGreen, width: 2),
                  color: Colors.white,
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: primaryGreen, size: 45),
                          const SizedBox(height: 8),
                          Text(
                            "Tambahkan Gambar",
                            style: GoogleFonts.poppins(
                              color: primaryGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    "Pilih Kategori",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  value: selectedCategory.isEmpty ? null : selectedCategory,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "Minuman", child: Text("Minuman")),
                    DropdownMenuItem(value: "Makanan", child: Text("Makanan")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategory = value!);
                  },
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
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
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (selectedCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Silakan pilih kategori")),
                        );
                        return;
                      }

                      final product = {
                        "name": nameController.text,
                        "price": priceController.text,
                        "stock": int.tryParse(stockController.text) ?? 0,
                        "category": selectedCategory,
                        "image": selectedImage ?? "assets/images/default.png",
                      };
                      Navigator.of(context, rootNavigator: true).pop(product);
                    },
                    child: Text(
                      "Konfirmasi",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            )),
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
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          height: 290,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text("Pilih Gambar",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(10),
                  children: [
                    _assetImageItem("assets/images/infused_timun.png"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _assetImageItem(String asset) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedImage = asset);
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(asset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
