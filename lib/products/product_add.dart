import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  File? selectedImageFile;
  Uint8List? webImageBytes;

  final ImagePicker picker = ImagePicker();
  final Color primaryGreen = const Color(0xFF558B2F);
  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();

  // ================= Validator =================
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nama produk wajib diisi";
    }
    if (value.trim().length < 3) {
      return "Nama minimal 3 karakter";
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return "Nama hanya boleh huruf dan spasi";
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Harga wajib diisi";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return "Harga hanya boleh angka";
    }
    return null;
  }

  String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Stok wajib diisi";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return "Stok hanya boleh angka";
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) return "Kategori wajib dipilih";
    return null;
  }

  String? validateImage() {
    if (selectedImageFile == null && webImageBytes == null) {
      return "Gambar produk wajib ditambahkan";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SingleChildScrollView(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
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

                // ================= IMAGE =================
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
                const SizedBox(height: 5),
                if (validateImage() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      validateImage()!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 18),

                // ================= NAME =================
                _inputField(
                  "Nama Produk",
                  nameController,
                  validator: validateName,
                ),
                const SizedBox(height: 12),

                // ================= PRICE =================
                _inputField(
                  "Harga Produk",
                  priceController,
                  keyboardType: TextInputType.number,
                  validator: validatePrice,
                ),
                const SizedBox(height: 12),

                // ================= STOCK =================
                _inputField(
                  "Stok",
                  stockController,
                  keyboardType: TextInputType.number,
                  validator: validateStock,
                ),
                const SizedBox(height: 12),

                // ================= CATEGORY =================
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
                if (validateCategory(selectedCategory) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      validateCategory(selectedCategory)!,
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 22),

                // ================= BUTTON =================
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
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // ================= IMAGE PICKER =================
  Future<void> _pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          webImageBytes = bytes;
          selectedImageFile = null;
        });
      } else {
        setState(() {
          selectedImageFile = File(image.path);
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
                Text(
                  "Pilih Gambar",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                      color: primaryGreen,
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

  // ================= IMAGE PREVIEW =================
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

  // ================= UPLOAD IMAGE =================
  Future<String> _uploadImage() async {
    if (selectedImageFile == null && webImageBytes == null) return "";

    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    if (kIsWeb && webImageBytes != null) {
      await supabase.storage.from('product_image').uploadBinary(fileName, webImageBytes!);
      return supabase.storage.from('product_image').getPublicUrl(fileName);
    }

    if (selectedImageFile != null) {
      await supabase.storage.from('product_image').upload(fileName, selectedImageFile!);
      return supabase.storage.from('product_image').getPublicUrl(fileName);
    }

    return "";
  }

  // ================= SAVE PRODUCT =================
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (validateCategory(selectedCategory) != null || validateImage() != null) return;

    double harga = double.parse(priceController.text.trim());
    int stok = int.parse(stockController.text.trim());

    setState(() => isSaving = true);

    try {
      final imageUrl = await _uploadImage();

      final productData = {
        "nama_produk": nameController.text.trim(),
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
}
