import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenora_pos/models/product.dart';
import 'package:greenora_pos/services/db_service.dart';


final dbServiceProvider = Provider<DbService>((ref) => DbService());

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
final db = ref.watch(dbServiceProvider);
return db.getProducts();
});