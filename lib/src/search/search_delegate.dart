import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = Pelicula_Provider();

  final peliculas = [
    'SpiderMan',
    'CapitanAmerica',
    'SpiderMan',
    'SapitanAmerica',
    'SpiderMan',
    'CapitanAmerica',
    'SpiderMan',
    'SapitanAmerica',
    'SpiderMan',
    'CapitanAmerica',
  ];

  final peliculasRecientes = [
    'SpiderMan',
    'CapitanAmerica',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    //Son las acciones del appBar
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //Icono a la izquierda del search
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    //Creacion de las peliculas
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueGrey,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Las sugerencias que aparecen cuando estamos tratando de buscar una pelicula
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;
            return ListView(
              children: peliculas!.map((pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit:BoxFit.contain
                  ),
                  title: Text(pelicula.title!),
                  subtitle: Text(pelicula.originalTitle!),
                  onTap: (){
                    close(context, null);
                    pelicula.uniqueId='';
                    Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                  },
                );
              }).toList()
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
