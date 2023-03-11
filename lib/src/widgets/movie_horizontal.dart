import 'package:flutter/material.dart';

import '../models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;

  final Function siguientePagina;

  MovieHorizontal({super.key, required this.peliculas, required this.siguientePagina});

  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });
    return SizedBox(
      height: screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return crearTarjeta(context, peliculas[i]);
        },
      ),
    );
  }
}

Widget crearTarjeta(BuildContext context, Pelicula pelicula) {
  pelicula.uniqueId ='${ pelicula.id}-poster';

  final tarjeta = Container(
    margin: const EdgeInsets.only(right: 20.0),
    child: Column(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Hero(
          tag: pelicula.uniqueId!,
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(pelicula.getPosterImg()),
            fit: BoxFit.cover,
            height: 160.0,
          ),
        ),
      ),
      const SizedBox(height: 10.0),
      Text(
        pelicula.title!,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      )
    ]),
  );
  return GestureDetector(
    child: tarjeta,
    onTap: (){
      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
    },
  );
}
