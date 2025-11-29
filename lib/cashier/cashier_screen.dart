import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenora_pos/widgets/header.dart';
import 'package:greenora_pos/widgets/sidebar.dart';
import 'package:greenora_pos/cashier/detail_cashierscreen.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({Key? key}) : super(key: key);

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  // Keranjang: tiap item {"name", "price", "quantity"}
  List<Map<String, dynamic>> cart = [];

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
      bool matchCategory =
          selectedCategory == "Semua" || p["category"] == selectedCategory;
      bool matchSearch =
          p["name"].toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: lightGreenBg,
      endDrawer: const SidebarWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (cart.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Keranjang kosong!")),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailCashierScreen(
                cart: cart,
                onConfirm: (confirmed) {
                  if (confirmed) {
                    setState(() {
                      // Kurangi stok produk
                      for (var item in cart) {
                        int index = products
                            .indexWhere((p) => p["name"] == item["name"]);
                        if (index != -1)
                          products[index]["stock"] -= item["quantity"];
                      }
                      cart.clear();
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        },
        label: Text("${cart.length} Item", style: GoogleFonts.poppins()),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: primaryGreen,
      ),
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
                    Text(
                      "Kasir",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: darkGray,
                      ),
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
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            if (product["stock"] <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("${product['name']} stok habis!")),
                              );
                              return;
                            }
                            setState(() {
                              int i = cart.indexWhere(
                                  (c) => c["name"] == product["name"]);
                              if (i != -1) {
                                cart[i]["quantity"] += 1;
                              } else {
                                cart.add({
                                  "name": product["name"],
                                  "price": product["price"],
                                  "quantity": 1,
                                });
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "${product['name']} ditambahkan ke keranjang")),
                            );
                          },
                          child: _buildProductCard(product),
                        );
                      },
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
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: Image.asset(product["image"],
                        fit: BoxFit.contain, height: 70)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w700, color: darkGray),
          ),
          Text(
            "Rp. ${product["price"]} | ${product["stock"]}",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600, color: primaryGreen),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
