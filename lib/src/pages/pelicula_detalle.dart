
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';


class PeliculaDetalle extends StatelessWidget {
  const PeliculaDetalle({super.key});

  @override
  Widget build(BuildContext context) {
     final pelicula = ModalRoute.of(context)!.settings.arguments as Pelicula;

    // ignore: prefer_const_constructors
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 60, 57, 70),
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppBar(pelicula),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10.0),
                  _posterTitulo(context,pelicula),
                  const SizedBox(height: 20.0),
                  const Center(
                    child: Text('Reseña de la pelicula',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  ),
                  ),
                  _descripcion(pelicula),
                  _crearElenco(pelicula),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(onPressed: (){}, child: const Text('Comprar Ticket')),
                      TextButton(onPressed: (){}, child: const Text('Ver trailer')),
                    ],
                  )
                ]
              )
              ),
          ],
        )
      ),
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
            style: const TextStyle(color: Colors.white,fontSize: 16.0),
          ),
          background: Image.network(pelicula.getBackdropPath(),
          fit:BoxFit.cover),
        )
        );
  }
  
  Widget _posterTitulo(BuildContext context , Pelicula pelicula) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId!,
            child: ClipRRect(
              borderRadius : BorderRadius.circular(10.0),
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
                Text(pelicula.title.toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle.toString(),style: Theme.of(context).textTheme.titleSmall,overflow: TextOverflow.ellipsis),
                Row(
                  children:<Widget> [
                      Icon(Icons.star_border,color: Colors.yellow[800],),
                      Text(pelicula.voteAverage.toString())
                  ],)
              ],
            ),
            )
        ],
        )
        );
  }

  Widget _descripcion(Pelicula pelicula){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(pelicula.overview.toString(),
          textAlign: TextAlign.justify,),   
        ],
      ),
    );
  }

  Widget _crearElenco(Pelicula pelicula){

    final peliProvider = Pelicula_Provider();
    
    return FutureBuilder(
      future: peliProvider.getActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot){
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }
      );
  }

  Widget _crearActoresPageView(List<Actor>? actores){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores?.length,
        itemBuilder: (context , i) =>_actorTarjeta(actores![i])
          
        ),
    );
  }

  Widget _actorTarjeta(Actor actor){
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/loading.gif'), 
            image: NetworkImage(actor.getImage()),
            height: 135.0,
            fit: BoxFit.cover,),  
        ),
        Text(actor.name!,
        overflow: TextOverflow.ellipsis,)
      ],
    );
  }
}
