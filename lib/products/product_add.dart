import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  String selectedCategory = "";
  String? selectedImageAsset;

  File? selectedImageFile;
  Uint8List? webImageBytes;

  final ImagePicker picker = ImagePicker();
  final Color primaryGreen = const Color(0xFF558B2F);

  bool isSaving = false;

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
                child: _buildImagePreview(),
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
                    onPressed: isSaving ? null : _saveProduct,
                    child: isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : Text(
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

  Future<void> _pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          webImageBytes = bytes;
          selectedImageFile = null;
          selectedImageAsset = null;
        });
      } else {
        setState(() {
          selectedImageFile = File(image.path);
          selectedImageAsset = null;
          webImageBytes = null;
        });
      }
    }
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Judul
                Text(
                  "Pilih Gambar",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol Galeri
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF558B2F),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickFromGallery();
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: Text(
                    "Ambil dari Galeri",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Batal
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF558B2F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _uploadImage() async {
    if (selectedImageAsset != null) return selectedImageAsset!;

    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    if (kIsWeb && webImageBytes != null) {
      await supabase.storage
          .from('product_image')
          .uploadBinary(fileName, webImageBytes!);
      return supabase.storage.from('product_image').getPublicUrl(fileName);
    }

    if (selectedImageFile != null) {
      await supabase.storage
          .from('product_image')
          .upload(fileName, selectedImageFile!);
      return supabase.storage.from('product_image').getPublicUrl(fileName);
    }

    return "";
  }

  Future<void> _saveProduct() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama produk wajib diisi")),
      );
      return;
    }
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kategori")),
      );
      return;
    }

    double? harga = double.tryParse(priceController.text);
    if (harga == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harga tidak valid")),
      );
      return;
    }

    int stok = int.tryParse(stockController.text) ?? 0;

    setState(() => isSaving = true);

    try {
      final imageUrl = await _uploadImage();

      final productData = {
        "nama_produk": nameController.text,
        "harga": harga,
        "stok": stok,
        "kategori": selectedCategory,
        "gambar": imageUrl,
      };

      await supabase.from("produk").insert(productData);

      Navigator.of(context, rootNavigator: true).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && webImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.memory(webImageBytes!, fit: BoxFit.cover),
      );
    }
    if (selectedImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(selectedImageFile!, fit: BoxFit.cover),
      );
    }
    if (selectedImageAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(selectedImageAsset!, fit: BoxFit.cover),
      );
    }
    return Column(
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
}
