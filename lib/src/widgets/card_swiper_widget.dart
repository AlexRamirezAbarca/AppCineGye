import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwipper extends StatelessWidget {
    final List<Pelicula> peliculas;
    CardSwipper({required this.peliculas});

  
  @override
  Widget build(BuildContext context) { 
    final screenSize = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(top:15.0),
        child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: screenSize.width*0.7,
          itemHeight: screenSize.height*0.5,
          itemBuilder: (BuildContext context,int index){
            peliculas[index].uniqueId='${ peliculas[index].id}-tarjeta';
            return Hero(
              tag: peliculas[index].uniqueId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    // ignore: prefer_const_constructors
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    ),
                )
              ),
            );
          },
          itemCount: peliculas.length,
        ),
      );
  }
}