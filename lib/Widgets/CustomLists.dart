import 'package:flutter/material.dart';
import 'package:flutter_application_2/Models/PopularMovies.dart';
import 'package:flutter_application_2/Models/TvShow.dart';
import 'package:flutter_application_2/Widgets/MovieCard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomListMovie extends StatefulWidget {
  CustomListMovie(this.data, {super.key});
  List<Results> data;

  @override
  State<CustomListMovie> createState() => _CustomListMovieState();
}

class _CustomListMovieState extends State<CustomListMovie>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length > 20 ? 20 : widget.data.length,
          cacheExtent: 9999,
          itemBuilder: ((context, index) {
            var url = widget.data[index].posterPath.toString();
            return KeyedSubtree(
                key: UniqueKey(),
                child: MovieCard(
                    widget.data[index].title.toString(),
                    CachedNetworkImageProvider(
                        "https://image.tmdb.org/t/p/w500$url"),
                    widget.data[index].id.toString(),
                    "movie"));
          }),
        ));
  }
}

class CustomListTV extends StatefulWidget {
  CustomListTV(this.data, {super.key});
  List<TvShow> data;

  @override
  State<CustomListTV> createState() => _CustomListTVState();
}

class _CustomListTVState extends State<CustomListTV>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length > 20 ? 20 : widget.data.length,
          itemBuilder: ((context, index) {
            var url = widget.data[index].posterPath.toString();
            return KeyedSubtree(
                key: UniqueKey(),
                child: MovieCard(
                    widget.data[index].name.toString(),
                    NetworkImage("https://image.tmdb.org/t/p/w500$url"),
                    widget.data[index].id.toString(),
                    "tv"));
          }),
        ));
  }
}

class CustomListMovieAdmin extends StatefulWidget {
  CustomListMovieAdmin(this.data, {super.key});
  List data;

  @override
  State<CustomListMovieAdmin> createState() => _CustomListMovieStateAdmin();
}

class _CustomListMovieStateAdmin extends State<CustomListMovieAdmin>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ImageProvider<Object> getCharacterAvatar(String url) {
    final image = Image.network(
      url,
      errorBuilder: (context, object, trace) {
        return const Image(image: AssetImage('assets/LoadingImage.png'));
      },
    ).image;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length > 20 ? 20 : widget.data.length,
          cacheExtent: 9999,
          itemBuilder: ((context, index) {
            var url = widget.data[index]['filmData']['poster'];

            return KeyedSubtree(
                key: UniqueKey(),
                child: MovieCard(
                    widget.data[index]['filmData']['filmName'],
                    getCharacterAvatar(url),
                    widget.data[index]['id'],
                    "movieAdmin"));
          }),
        ));
  }
}
