import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieDetailProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleAndOverview(movie:movie,size:size,textStyles:textStyles),
        _Genres(movie:movie),
        ActorsByMovie(movieId: movie.id.toString()),
        SimilarMovies(movieId:movie.id)
      ],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        children: [
          ...movie.genreIds.map((gender) => Container(
            margin: const EdgeInsets.only( right: 10),
            child: Chip(
              label: Text( gender ),
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
            ),
          ))
        ],
      ),
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 8, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width * 0.3,
            ),
          ),
          const SizedBox( width: 10 ),
          // Descripción
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( movie.title, style: textStyles.titleLarge ),
                Text( movie.overview ),

                const SizedBox(height: 10),

                MovieRating(voteAverage: movie.voteAverage),
                
                Row(
                  children: [
                    const Text('Estreno:',style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 5,),
                    Text(HumanFormats.shortData(movie.releaseDate))
                  ],
                )
              ],
            ),
          )
        ]
      )
    );
  }
}






final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});
class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(onPressed: () async{
          // ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
          await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

          ref.invalidate(isFavoriteProvider(movie.id));
        }, 
        // icon: const Icon(Icons.favorite_border)
        icon: isFavoriteFuture.when(
          data: (isFavorite) => isFavorite
          ? const Icon(Icons.favorite_rounded, color: Colors.red)
          : const Icon(Icons.favorite_border_rounded), 
          error: (_,__) => throw UnimplementedError(), 
          loading: () => const CircularProgressIndicator(strokeWidth: 2))
        // const Icon(Icons.favorite_rounded, color: Colors.red,),
      )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(begin:Alignment.topCenter,end: Alignment.bottomCenter,stops: const [0.7,1.0], colors: [Colors.transparent,scaffoldBackgroundColor]),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              )
            ),
            const _CustomGradient(begin: Alignment.topLeft, stops: [0.0,0.3], colors: [Colors.black87,Colors.transparent]),
            const _CustomGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, stops: [0.0,0.2], colors: [Colors.black54,Colors.transparent]),
      
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {

  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.centerLeft, 
    this.end = Alignment.centerRight, 
    required this.stops, 
    required this.colors}
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: begin,
                          end: end,
                          stops: stops,
                          colors: colors
                      )
                  )
                ),
            );
  }
}
