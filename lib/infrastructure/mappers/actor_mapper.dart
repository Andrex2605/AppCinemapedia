


import 'package:cinemapedia/domain/entities/actors.dart';

class ActorMapper{

  static Actor castToEntity(cast) => 
    Actor(
      id: cast.id, 
      name: cast.name, 
      profilePath: cast.profilePath != null 
      ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}' 
      : 'https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg', 
      character: cast.character
    );
}