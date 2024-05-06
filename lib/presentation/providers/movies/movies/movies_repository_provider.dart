
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//solo lectura, es inmutable
final movieRepositoryProvider = Provider((ref){

  return MovieRepositoryImpl(MovieDbDatasource());

});