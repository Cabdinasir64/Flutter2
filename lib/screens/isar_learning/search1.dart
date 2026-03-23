import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme2.dart';
class Search1Screen extends StatefulWidget {
  final Isar isar;
  const Search1Screen({super.key, required this.isar});

  @override
  State<Search1Screen> createState() => _Search1ScreenState();
}

class _Search1ScreenState extends State<Search1Screen> {
  List<Product> searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _performSearch(""); 
  }

  void _performSearch(String query) async {
    final queryBuilder = widget.isar.products.filter();
    
    List<Product> results;

    if (query.isEmpty) {
      results = await widget.isar.products.where().findAll();
    } else {
      results = await queryBuilder
          .nameContains(query, caseSensitive: false)
          .or()
          .categoryContains(query, caseSensitive: false)
          .findAll();
    }

    setState(() => searchResults = results);
  }

  void _addSampleData() async {
    final p1 = Product()..name = "iPhone 15"..category = "Electronics"..price = 999;
    final p2 = Product()..name = "Samsung S23"..category = "Electronics"..price = 850;
    final p3 = Product()..name = "Nike Shoes"..category = "Fashion"..price = 120;
    final p4 = Product()..name = "Macbook Air"..category = "Electronics"..price = 1200;

    await widget.isar.writeTxn(() => widget.isar.products.putAll([p1, p2, p3, p4]));
    _performSearch("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isar Advanced Search"),
        actions: [IconButton(icon: const Icon(Icons.library_add), onPressed: _addSampleData)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by Name or Category...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => _performSearch(value), 
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, i) {
                final product = searchResults[i];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.category),
                  trailing: Text("\$${product.price}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}