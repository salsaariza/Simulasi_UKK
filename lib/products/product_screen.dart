import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/products/product_add.dart';
import 'package:greenora_pos/products/product_edit.dart';
import 'package:greenora_pos/products/product_delete.dart';

final supabase = Supabase.instance.client;

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  final Color primaryGreen = const Color(0xFF558B2F);
  final Color lightGreenBg = const Color(0xFFDCEFD6);
  final Color darkGray = const Color(0xFF424242);
  final Color lightGray = const Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ---------------------------------------------------------
  // FETCH PRODUK
  // ---------------------------------------------------------
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final data = await supabase
          .from('produk')
          .select()
          .order('nama_produk', ascending: true);

      setState(() {
        products = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // FILTERING PRODUK
    List<Map<String, dynamic>> filtered = products.where((p) {
      bool matchCategory = selectedCategory == "Semua" ||
          p["kategori"].toString().toLowerCase().trim() ==
              selectedCategory.toLowerCase();

      bool matchSearch = p["nama_produk"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchCategory && matchSearch;
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
                          //--------------------------------------------------
                          // HEADER PRODUK
                          //--------------------------------------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Produk",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: darkGray,
                                ),
                              ),

                              // Tambah Produk
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 30, color: Color(0xFF424242)),
                                onPressed: () async {
                                  // Show AddProduct dialog
                                  final bool? result = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => const AddProduct(),
                                  );

                                  // Hanya refresh jika produk ditambahkan
                                  if (result == true) {
                                    await fetchProducts();
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          //--------------------------------------------------
                          // SEARCH BAR
                          //--------------------------------------------------
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryGreen.withOpacity(0.5),
                              ),
                            ),
                            child: TextField(
                              onChanged: (v) =>
                                  setState(() => searchQuery = v),
                              decoration: InputDecoration(
                                hintText: "Cari Produk",
                                hintStyle:
                                    GoogleFonts.poppins(color: lightGray),
                                border: InputBorder.none,
                                suffixIcon:
                                    Icon(Icons.search, color: primaryGreen),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          //--------------------------------------------------
                          // FILTER CATEGORY
                          //--------------------------------------------------
                          Row(
                            children: [
                              _filterTab("Semua"),
                              const SizedBox(width: 8),
                              _filterTab("Minuman"),
                              const SizedBox(width: 8),
                              _filterTab("Makanan"),
                            ],
                          ),

                          const SizedBox(height: 16),

                          //--------------------------------------------------
                          // GRID PRODUK
                          //--------------------------------------------------
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) =>
                                _buildCard(filtered[i]),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // WIDGET FILTER
  // ---------------------------------------------------------
  Widget _filterTab(String category) {
    bool active = category == selectedCategory;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryGreen),
        ),
        child: Text(
          category,
          style: GoogleFonts.poppins(
            color: active ? Colors.white : primaryGreen,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // KARTU PRODUK
  // ---------------------------------------------------------
  Widget _buildCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryGreen.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // GAMBAR
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: (product["gambar"] != null &&
                          product["gambar"].toString().isNotEmpty)
                      ? Image.network(product["gambar"],
                          fit: BoxFit.contain, height: 75)
                      : const Icon(Icons.image,
                          size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // NAMA PRODUK
          Text(
            product["nama_produk"] ?? "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: darkGray,
            ),
          ),

          // HARGA & STOK
          Text(
            "Rp. ${product["harga"]} | ${product["stok"]}",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 8),

          // BUTTON EDIT & DELETE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // EDIT
              IconButton(
                icon: Icon(Icons.edit, color: darkGray, size: 20),
                onPressed: () async {
                  final bool? result = await showDialog<bool>(
                    context: context,
                    builder: (_) => ProductEdit(
                      key: ValueKey(product["id"]),
                      product: product,
                    ),
                  );

                  if (result == true) {
                    await fetchProducts();
                  }
                },
              ),

              const SizedBox(width: 8),

              // DELETE
              IconButton(
                icon: Icon(Icons.delete, color: darkGray, size: 20),
                onPressed: () async {
                  final bool? del = await showDialog<bool>(
                    context: context,
                    builder: (_) => ProductDelete(
                      productId: product["id"],
                      productName: product["nama_produk"],
                    ),
                  );

                  if (del == true) {
                    await supabase
                        .from("produk")
                        .delete()
                        .eq("id", product["id"]);

                    await fetchProducts();
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
