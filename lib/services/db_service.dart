import 'package:greenora_pos/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService {
  final SupabaseClient _client = Supabase.instance.client;


  // GET ALL PRODUCTS
  Future<List<Product>> getProducts() async {
    final List<dynamic> res = await _client
        .from('produk')
        .select()
        .order('produk_id');

    return res.map((e) => Product.fromMap(e)).toList();
  }

  // CREATE PRODUCT
  Future<Product> createProduct(Product p) async {
    final Map<String, dynamic> res = await _client
        .from('produk')
        .insert(p.toMap())
        .select()
        .single();

    return Product.fromMap(res);
  }

  // UPDATE PRODUCT
  Future<void> updateProduct(int produkId, Map<String, dynamic> changes) async {
    await _client
        .from('produk')
        .update(changes)
        .eq('produk_id', produkId);
  }

  // DELETE PRODUCT
  Future<void> deleteProduct(int produkId) async {
    await _client
        .from('produk')
        .delete()
        .eq('produk_id', produkId);
  }
}
