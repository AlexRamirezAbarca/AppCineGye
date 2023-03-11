import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

import '../models/pelicula_model.dart';

class HomePage extends StatelessWidget {
  
  final peliculasProvider = Pelicula_Provider();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cine Gye'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 40, 40, 41),
          actions:<Widget> [
            IconButton(
              icon:const Icon (Icons.search),
              onPressed: (){
                showSearch(
                  context: context, 
                  delegate: PeliculaSearch(),
                  
                  );
              },
            )
          ],
        ),
        body: Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              const SizedBox(height : 20.0),
              _footer(context)
            ],
          ),
        )
      ),
    );
  }

    Widget _swiperTarjetas(){
      return FutureBuilder(
        future: peliculasProvider.getEnCines(),
        builder: (BuildContext context , AsyncSnapshot <List<Pelicula>> snapshot){
            if(snapshot.hasData){
              return CardSwipper( peliculas: snapshot.data!);
            }else{
              return const SizedBox(
                height: 400.0,
                child: Center(
                  child : CircularProgressIndicator()
                ),
              );
            }
        },
        ); 
    }


    Widget _footer(BuildContext context){
      return SizedBox(
        width: double.infinity,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Populares',style: Theme.of(context).textTheme.subtitle1)),
            const SizedBox(height: 5.0),
            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
                if(snapshot.hasData){
                  return MovieHorizontal(peliculas: snapshot.data!,
                  siguientePagina: peliculasProvider.getPopulares);
                }else{
                  const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
              ),
          ],
        ), 
      );
    }
}

