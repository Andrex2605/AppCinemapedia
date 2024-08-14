import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
      : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elmundo.es%2Fcomo%2F2024%2F03%2F08%2F65ead9c0e9cf4a342c8b45b6.html&psig=AOvVaw1cZp-dWZieHkJhSZ7X1ly9&ust=1715019744498000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIiI4seQ94UDFQAAAAAdAAAAABAE',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'no-poster',
      releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);


    static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
      : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elmundo.es%2Fcomo%2F2024%2F03%2F08%2F65ead9c0e9cf4a342c8b45b6.html&psig=AOvVaw1cZp-dWZieHkJhSZ7X1ly9&ust=1715019744498000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIiI4seQ94UDFQAAAAAdAAAAABAE',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
      : 'no-poster',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
    
}
