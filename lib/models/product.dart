class Product {
final int? produkId;
final String namaProduk;
final double harga;
final int stok;


Product({this.produkId, required this.namaProduk, required this.harga, required this.stok});


factory Product.fromMap(Map<String, dynamic> map) {
return Product(
produkId: map['produk_id'] as int?,
namaProduk: map['nama_produk'] as String,
harga: (map['harga'] as num).toDouble(),
stok: (map['stok'] as num).toInt(),
);
}


Map<String, dynamic> toMap() => {
if (produkId != null) 'produk_id': produkId,
'nama_produk': namaProduk,
'harga': harga,
'stok': stok,
};
}