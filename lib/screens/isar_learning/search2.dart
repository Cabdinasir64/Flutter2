import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme2.dart';
class Search2Screen extends StatefulWidget {
  final Isar isar;
  const Search2Screen({super.key, required this.isar});

  @override
  State<Search2Screen> createState() => _Search2ScreenState();
}

class _Search2ScreenState extends State<Search2Screen> {
  List<Product> results = [];
  String searchMode = "Name"; 

  void _search(String query) async {
    final filter = widget.isar.products.filter();
    List<Product> finalResults;

    switch (searchMode) {
      case "Name":
        finalResults = await filter.nameStartsWith(query, caseSensitive: false).findAll();
        break;

      case "Price":
        double? maxPrice = double.tryParse(query);
        if (maxPrice == null) return;
        finalResults = await filter.priceLessThan(maxPrice).findAll();
        break;

      case "Category":
        finalResults = await filter.categoryEqualTo(query, caseSensitive: false).findAll();
        break;

      case "Stock":
        finalResults = await filter.inStockEqualTo(true).nameContains(query).findAll();
        break;

      default:
        finalResults = await widget.isar.products.where().findAll();
    }

    setState(() => results = finalResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Search Methods"),
        actions: [IconButton(icon: const Icon(Icons.add_to_photos), onPressed: _addDiversifiedData)],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["Name", "Price", "Category", "Stock"].map((mode) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(mode),
                    selected: searchMode == mode,
                    onSelected: (val) => setState(() => searchMode = mode),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Searching by $searchMode...",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final p = results[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text("${p.category} | In Stock: ${p.inStock}"),
                  trailing: Text("\$${p.price}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addDiversifiedData() async {
    final products = [
      Product()..name = "Apple iPhone 15"..category = "Electronics"..price = 1000..inStock = true,
      Product()..name = "Apple MacBook Pro"..category = "Electronics"..price = 2500..inStock = true,
      Product()..name = "Samsung Galaxy S23"..category = "Electronics"..price = 900..inStock = false,
      Product()..name = "Nike Air Max"..category = "Shoes"..price = 150..inStock = true,
      Product()..name = "Adidas Ultraboost"..category = "Shoes"..price = 180..inStock = true,
      Product()..name = "Sony Headphones"..category = "Electronics"..price = 300..inStock = false,
      Product()..name = "Leather Jacket"..category = "Clothing"..price = 450..inStock = true,
      Product()..name = "Denim Jeans"..category = "Clothing"..price = 60..inStock = true,
    ];
    await widget.isar.writeTxn(() => widget.isar.products.putAll(products));
    _search("");
  }
}