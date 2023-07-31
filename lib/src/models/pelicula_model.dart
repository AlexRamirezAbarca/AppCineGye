class Peliculas {

  List<Pelicula> items =[];

  Peliculas();

  Peliculas.fromJsonList( List<dynamic> jsonList  ) {

    if ( jsonList == null ) return;

    for ( var item in jsonList  ) {
      final pelicula = Pelicula.fromJsonMap(item);
      items.add( pelicula );
    }
  }
}

class Pelicula {
  String? idVideo;
  String? uniqueId;
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video=false;
  double? voteAverage;
  int? voteCount;

  Pelicula({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });


  Pelicula.fromJsonMap(Map <String,dynamic>json){
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity']/1;
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'] /1;
    voteCount = json['vote_count'];
  }

  getPosterImg(){
    if(posterPath==null){
      return 'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
    
  }

  getBackdropPath(){
    if(posterPath==null){
      return 'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}
