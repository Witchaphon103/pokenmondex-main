import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/views/pokemonlist_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Pokemon App',
            style: TextStyle(
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
        body: const PokemonList(),
      ),
    );
  }
}
