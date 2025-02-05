import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({Key? key, required this.pokemonListItem})
      : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? pokemonData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemonData = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemonListItem.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 143, 106, 199),
                Color.fromARGB(255, 98, 65, 218)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: pokemonData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.pokemonListItem.name,
                      child: Image.network(widget.pokemonListItem.imageUrl,
                          height: 150),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              widget.pokemonListItem.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Text(
                              "ประเภท: ${pokemonData!['types'].map((t) => t['type']['name']).join(', ')}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "ค่าพลัง:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView(
                                children:
                                    pokemonData!['stats'].map<Widget>((stat) {
                                  return ListTile(
                                    title: Text(
                                      "${stat['stat']['name']}: ${stat['base_stat']}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    leading: const Icon(Icons.bolt,
                                        color: Colors.orange),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
