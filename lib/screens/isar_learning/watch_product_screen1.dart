import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme2.dart';

class WatchProductScreen extends StatefulWidget {
  final Isar isar;
  const WatchProductScreen({super.key, required this.isar});

  @override
  State<WatchProductScreen> createState() => _WatchProductScreenState();
}

class _WatchProductScreenState extends State<WatchProductScreen> {
  late Stream<List<Product>> productStream;

  @override
  void initState() {
    super.initState();
    productStream = widget.isar.products.where().watch(fireImmediately: true);
  }

  void _addProduct() async {
    final newProduct = Product()
      ..name = "Product ${DateTime.now().second}"
      ..category = "Electronics"
      ..price = 199.99;

    await widget.isar.writeTxn(() => widget.isar.products.put(newProduct));
  }

  void _updateProduct(Product product) async {
    product.name = "${product.name} (Updated)";
    product.price = product.price + 10.0;

    await widget.isar.writeTxn(() => widget.isar.products.put(product));
  }

  void _deleteProduct(int id) async {
    await widget.isar.writeTxn(() => widget.isar.products.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isar Full Reactive CRUD"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Product>>(
        stream: productStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(child: Text("Database-ku waa madhan yahay."));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${p.id}")),
                  title: Text(
                    p.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Price: \$${p.price.toStringAsFixed(2)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _updateProduct(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(p.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _addProduct,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}