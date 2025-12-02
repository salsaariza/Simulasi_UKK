import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  File? selectedImageFile;
  Uint8List? webImageBytes;
  String? imageUrl;

  final Color primaryGreen = const Color(0xFF558B2F);
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product["nama_produk"]);
    priceController = TextEditingController(text: widget.product["harga"].toString());
    stockController = TextEditingController(text: widget.product["stok"].toString());
    selectedCategory = widget.product["kategori"] ?? "";
    imageUrl = widget.product["gambar"];
  }

  // ================= Validators =================
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Nama produk wajib diisi";
    if (value.trim().length < 3) return "Nama minimal 3 karakter";
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return "Harga wajib diisi";
    if (double.tryParse(value) == null) return "Harga harus angka";
    return null;
  }

  String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) return "Stok wajib diisi";
    if (int.tryParse(value) == null) return "Stok harus angka";
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) return "Kategori wajib dipilih";
    return null;
  }

  String? validateImage() {
    if (imageUrl == null && selectedImageFile == null && webImageBytes == null) {
      return "Gambar produk wajib ditambahkan";
    }
    return null;
  }

  // ================= Pick Image =================
  Future<void> _pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          webImageBytes = bytes;
          selectedImageFile = null;
          imageUrl = null;
        });
      } else {
        setState(() {
          selectedImageFile = File(image.path);
          webImageBytes = null;
          imageUrl = null;
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickFromGallery();
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: Text(
                    "Ambil dari Galeri",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.poppins(
                        color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= Upload Image =================
  Future<String> _uploadImage() async {
    if (imageUrl != null) return imageUrl!;
    final supabase = Supabase.instance.client;
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

  // ================= Update Product =================
  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (validateCategory(selectedCategory) != null || validateImage() != null) return;

    setState(() => isSaving = true);

    try {
      final supabase = Supabase.instance.client;
      final int id = widget.product["id"];

      final updatedImageUrl = await _uploadImage();

      await supabase.from('produk').update({
        "nama_produk": nameController.text.trim(),
        "harga": double.parse(priceController.text.trim()),
        "stok": int.parse(stockController.text.trim()),
        "kategori": selectedCategory,
        "gambar": updatedImageUrl,
        "updated_at": DateTime.now().toIso8601String()
      }).eq("id", id);

      // popup sukses
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                      fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // tutup popup sukses
                    Navigator.pop(context, true); // kembali ke screen utama
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                  ),
                  child: Text(
                    "OK",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  // ================= Input Field =================
  Widget _inputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // ================= Build =================
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Produk",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),

                // IMAGE
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
                    child: imageUrl == null && selectedImageFile == null && webImageBytes == null
                        ? Center(
                            child: Text("Tambahkan Gambar",
                                style: GoogleFonts.poppins(color: primaryGreen)),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: kIsWeb && webImageBytes != null
                                ? Image.memory(webImageBytes!, fit: BoxFit.cover)
                                : selectedImageFile != null
                                    ? Image.file(selectedImageFile!, fit: BoxFit.cover)
                                    : Image.network(imageUrl!, fit: BoxFit.cover),
                          ),
                  ),
                ),
                if (validateImage() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      validateImage()!,
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 18),

                // NAME
                _inputField("Nama Produk", nameController, validator: validateName),
                const SizedBox(height: 12),

                // PRICE
                _inputField("Harga Produk", priceController,
                    keyboardType: TextInputType.number, validator: validatePrice),
                const SizedBox(height: 12),

                // STOCK
                _inputField("Stok", stockController,
                    keyboardType: TextInputType.number, validator: validateStock),
                const SizedBox(height: 12),

                // CATEGORY
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
                              color: selectedCategory.isEmpty
                                  ? Colors.grey
                                  : Colors.black),
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
                if (validateCategory(selectedCategory) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      validateCategory(selectedCategory)!,
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 22),

                // BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Batal",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                        onPressed: isSaving ? null : updateProduct,
                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : Text("Simpan",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
