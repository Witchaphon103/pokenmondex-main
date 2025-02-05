import 'package:flutter/material.dart';
import 'package:pokemondex/pokemondetail/views/pokemondetail_view.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<List<PokemonListItem>> _list;
  String? nextUrl = 'https://pokeapi.co/api/v2/pokemon';

  @override
  void initState() {
    super.initState();
    _list = loadData();
  }

  Future<List<PokemonListItem>> loadData() async {
    if (nextUrl == null) return [];

    final response = await http.get(Uri.parse(nextUrl!));
    if (response.statusCode == 200) {
      final PokemonListResponse data =
          PokemonListResponse.fromJson(jsonDecode(response.body));

      setState(() {
        nextUrl = data.next;
      });

      return data.results;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 143, 106, 199),
            Color.fromARGB(255, 98, 65, 218)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FutureBuilder<List<PokemonListItem>>(
        future: _list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pokemon found'));
          } else {
            final List<PokemonListItem> response = snapshot.data!;

            return ListView.builder(
              itemCount: response.length + 1,
              itemBuilder: (context, index) {
                if (index == response.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _list = loadData();
                        });
                      },
                      child: const Text('โหลดเพิ่มเติม'),
                    ),
                  );
                }

                final PokemonListItem pokemon = response[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: Hero(
                      tag: pokemon.name,
                      child: Image.network(pokemon.imageUrl, height: 50),
                    ),
                    title: Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemondetailView(
                          pokemonListItem: pokemon,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
