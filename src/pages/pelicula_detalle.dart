// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PeliculaDetalle extends StatefulWidget {

  double getRandomDouble(){
      Random random = Random();
      return (random.nextDouble() * 6) + 3;
    } 
  const PeliculaDetalle({super.key});

  @override
  State<PeliculaDetalle> createState() => _PeliculaDetalleState();
}

class _PeliculaDetalleState extends State<PeliculaDetalle> {
  @override
  Widget build(BuildContext context) {
    Pelicula_Provider peliculaProvider = Pelicula_Provider();
    final pelicula = ModalRoute.of(context)!.settings.arguments as Pelicula;
    bool comprando = false;

   
    void _cerrarDialog() {
      Navigator.pop(context); // cierra el Dialog
      setState(() {
        comprando = false;
      });
      // Navegar de vuelta a la página principal aquí
    }
    
    void _mostrarDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              color: const Color(0xFFCFDDE3),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  SizedBox(height: 25.0),
                  Text('Comprando...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ],
              ),
            ),
          );
        },
      );
      Timer(const Duration(seconds: 4), _cerrarDialog);
    }

    void _presentarVideo(BuildContext context, String videoId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFF26526A),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 40, 40, 41),
                title: Text(pelicula.title!),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    posterTitulo(context, pelicula),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: videoId,
                            flags: const YoutubePlayerFlags(
                              autoPlay: true,
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ),
                    _descripcion(pelicula)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    _crearBotonTrailer(BuildContext context, Pelicula pelicula) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ElevatedButton.icon(
          onPressed: () async {
            final videoId = await peliculaProvider.obtenerVideoId(pelicula);
            if (videoId != null) {
              // ignore: use_build_context_synchronously
              _presentarVideo(context, videoId);
            } else {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Trailer no disponible'),
                    content: const Text(
                        'Lo sentimos, no se ha encontrado un trailer para esta película.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Trailer'),
        ),
      );
    }

    

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF26526A),
          body: CustomScrollView(
            slivers: <Widget>[
              _crearAppBar(pelicula),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(height: 10.0),
                posterTitulo(context, pelicula),
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                    'Reseña de la pelicula',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _descripcion(pelicula),
                _crearElenco(pelicula),
                _crearBotonTrailer(context, pelicula),
              ])),
            ],
          )),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        expandedHeight: 180.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            pelicula.title.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          background:
              Image.network(pelicula.getBackdropPath(), fit: BoxFit.cover),
        ));
  }

  Widget posterTitulo(BuildContext context, Pelicula pelicula) {
    double precio = widget.getRandomDouble();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
              ),
            ),
            const SizedBox(width: 25.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(pelicula.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18)),
                  Text(pelicula.originalTitle.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star_border,
                        color: Colors.yellow[800],
                      ),
                      const SizedBox(width: 3),
                      Text(pelicula.voteAverage.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money_rounded,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 3),
                      Text(precio.toStringAsFixed(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15))
                    ],
                  ),
                  crearBotonAsientos(context,precio)
                ],
              ),
            )
          ],
        ));
  }

  Widget _descripcion(Pelicula pelicula) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(pelicula.overview.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17)),
        ],
      ),
    );
  }

  Widget _crearElenco(Pelicula pelicula) {
    final peliProvider = Pelicula_Provider();

    return FutureBuilder(
        future: peliProvider.getActores(pelicula.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
          if (snapshot.hasData) {
            return _crearActoresPageView(snapshot.data);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearActoresPageView(List<Actor>? actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemCount: actores?.length,
          itemBuilder: (context, i) => _actorTarjeta(actores![i])),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/loading.gif'),
            image: NetworkImage(actor.getImage()),
            height: 135.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(actor.name!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14))
      ],
    );
  }
  
  crearBotonAsientos(BuildContext context, double precio) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton.icon(
          onPressed: () {
            _valorPelicula(precio);
            Navigator.pushNamed(context, 'asientos');
          },
          icon: const Icon(Icons.chair_outlined),
          label: const Text('Seleccionar Asientos'),
        ),
      );
  }
  
  Future<void> _valorPelicula(double valor)async{
      SharedPreferences prefsPelicula = await SharedPreferences.getInstance();
      double valorPelicula = valor;
      await prefsPelicula.setDouble('precioPelicula', valorPelicula);
     } 
}
