import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMovieCallback searchMovies;

  SearchMovieDelegate({required this.searchMovies});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(child: IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''))
      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context,null), 
      icon: const Icon(Icons.arrow_back_ios_new)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchMovies(query), 
      builder: (context, snapshot){

        final movies = snapshot.data ?? [];

        return ListView.builder(itemCount: movies.length,itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(title: Text(movie.title), subtitle: Text(movie.overview));
        },);
      }
    );
  }

}