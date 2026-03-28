import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme2.dart';

class WatchProductScreen2 extends StatefulWidget {
  final Isar isar;
  const WatchProductScreen2({super.key, required this.isar});

  @override
  State<WatchProductScreen2> createState() => _WatchProductScreen2State();
}

class _WatchProductScreen2State extends State<WatchProductScreen2> {
  String selectedCategory = "All";

  Stream<List<Product>> getDynamicStream() {
    if (selectedCategory == "All") {
      return widget.isar.products.where().watch(fireImmediately: true);
    } else {
      return widget.isar.products
          .filter()
          .categoryEqualTo(selectedCategory)
          .watch(fireImmediately: true);
    }
  }

  void _addSampleProduct(String cat) async {
    final p = Product()
      ..name = "$cat Product ${DateTime.now().second}"
      ..category = cat
      ..price = (cat == "Electronics") ? 500.0 : 50.0;

    await widget.isar.writeTxn(() => widget.isar.products.put(p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isar Filtered Watch"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["All", "Electronics", "Fashion"].map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: selectedCategory == cat,
                  onSelected: (val) => setState(() => selectedCategory = cat),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: getDynamicStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    final p = products[i];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(p.name),
                      subtitle: Text("Category: ${p.category}"),
                      trailing: Text("\$${p.price}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSampleProduct(
          selectedCategory == "All" ? "Electronics" : selectedCategory,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
