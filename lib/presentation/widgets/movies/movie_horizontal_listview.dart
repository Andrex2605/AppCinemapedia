// ignore_for_file: unnecessary_null_comparison

import 'package:cinemapedia/presentation/widgets/movies/movie_rating.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';


class MovieHorizontalListView extends StatefulWidget {

  final List<Movie> movies;
  final String title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListView({super.key, required this.movies, required this.title,  this.subTitle, this.loadNextPage});

  @override
  State<MovieHorizontalListView> createState() => _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if (scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      } 
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title !=  null || widget.subTitle != null) 
            _Title(title: widget.title, subTitle: widget.subTitle!),
          
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context,index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              }
            )
          )
        ]
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () => context.push('/home/0/movie/${movie.id}'),
                child: FadeInImage(
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/loaders/bottle-loader.gif'), 
                  image: NetworkImage(movie.posterPath)),
              ),
            )
          ),

          const SizedBox(height: 5),

          SizedBox(width: 150,
            child: Text(movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            )
          ),
          MovieRating(voteAverage: movie.voteAverage)
        ],
      )
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final String subTitle;
  const _Title({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      child: Row(
        children: [
          if(title != null)
            Text(title,style: titleStyle),
          const Spacer(),
          if(subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: (){}, 
              child: Text(subTitle)),
          
        ],
      ),
    );
  }
}