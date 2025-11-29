import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/products/product_edit.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/products/product_add.dart';
import 'package:greenora_pos/products/product_delete.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  final List<Map<String, dynamic>> products = [
    {"name": "Jus Stroberi", "price": "12.000", "stock": 2, "category": "Minuman", "image": "assets/images/jus_strawberry.png"},
    {"name": "Jus Alpukat", "price": "15.000", "stock": 10, "category": "Minuman", "image": "assets/images/jus_alpukat.png"},
    {"name": "Jus Mangga", "price": "10.000", "stock": 10, "category": "Minuman", "image": "assets/images/jus_mangga.png"},
    {"name": "Jus Kiwi", "price": "15.000", "stock": 8, "category": "Minuman", "image": "assets/images/jus_kiwi.png"},
    {"name": "Jus Bluberi", "price": "15.000", "stock": 5, "category": "Minuman", "image": "assets/images/jus_bluberi.png"},
    {"name": "Jus Semangka", "price": "10.000", "stock": 8, "category": "Minuman", "image": "assets/images/jus_semangka.png"},
    {"name": "Jus Jambu", "price": "10.000", "stock": 15, "category": "Minuman", "image": "assets/images/jus_jambu.png"},
    {"name": "Jus Pepaya", "price": "12.000", "stock": 5, "category": "Minuman", "image": "assets/images/jus_pepaya.png"},
    {"name": "Jus Timun", "price": "10.000", "stock": 8, "category": "Minuman", "image": "assets/images/jus_timun.png"},
    {"name": "Ayam Panggang", "price": "20.000", "stock": 12, "category": "Makanan", "image": "assets/images/ayam_panggang.png"},
    {"name": "Salad Sayur", "price": "20.000", "stock": 15, "category": "Makanan", "image": "assets/images/salad_sayur.png"},
    {"name": "Salad Gulung", "price": "20.000", "stock": 15, "category": "Makanan", "image": "assets/images/salad_gulung.png"},
  ];

  final Color primaryGreen = const Color(0xFF558B2F);
  final Color lightGreenBg = const Color(0xFFDCEFD6);
  final Color darkGray = const Color(0xFF424242);
  final Color lightGray = const Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    List filteredProducts = products.where((p) {
      bool matchCategory = selectedCategory == "Semua" || p["category"] == selectedCategory;
      bool matchSearch = p["name"].toLowerCase().contains(searchQuery.toLowerCase());
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 30, color: Color(0xFF424242)),
                          onPressed: () async {
                            final newProduct = await showDialog<Map<String, dynamic>>(
                              context: context,
                              builder: (_) => const AddProduct(),
                            );
                            if (newProduct != null) {
                              setState(() => products.add(newProduct));
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
                                          "Berhasil Ditambah",
                                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 18),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryGreen,
                                            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                                          ),
                                          child: Text("OK", style: GoogleFonts.poppins(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryGreen.withOpacity(0.5)),
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => searchQuery = value),
                        decoration: InputDecoration(
                          hintText: "Cari Produk",
                          hintStyle: GoogleFonts.poppins(color: lightGray),
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search, color: primaryGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildFilterTab("Semua"),
                        const SizedBox(width: 8),
                        _buildFilterTab("Minuman"),
                        const SizedBox(width: 8),
                        _buildFilterTab("Makanan"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
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

  Widget _buildFilterTab(String category) {
    bool isActive = selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryGreen),
        ),
        child: Text(
          category,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.white : primaryGreen,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryGreen.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Center(child: Image.asset(product["image"], fit: BoxFit.contain, height: 70)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: darkGray),
          ),
          Text(
            "Rp. ${product["price"]} | ${product["stock"]}",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: primaryGreen),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 20, color: darkGray),
                onPressed: () async {
                  final editedProduct = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => ProductEdit(key: ValueKey(product["name"]), product: product),
                  );
                  if (editedProduct != null) {
                    setState(() {
                      int index = products.indexOf(product);
                      if (index != -1) products[index] = editedProduct;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete, size: 20, color: darkGray),
                onPressed: () async {
                  final confirm = await showDialog<bool>(context: context, builder: (_) => ProductDelete(productName: product["name"]));
                  if (confirm == true) setState(() => products.remove(product));
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
