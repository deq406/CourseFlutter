import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Models/PopularMovies.dart';
import 'package:flutter_application_2/Services/API.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:flutter_application_2/Widgets/CustomLists.dart';
import 'package:flutter_application_2/Widgets/LoadingScreen.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_application_2/Services/extraServices.dart';
import 'package:flutter_application_2/Widgets/DetailScreenComponents.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen(this.movieId, {super.key});
  String movieId;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  bool isLoading = true;
  late List<Results> recommendedMovies;

  Future<void> fetchData() async {
    recommendedMovies = await APIService().getRecommendedMovie(widget.movieId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_primary,
      body: isLoading
          ? LoadingScreen()
          : FutureBuilder(
              future: APIService().getMovieDetail(widget.movieId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var status = snapshot.data!.status.toString();
                  var releaseDate = snapshot.data!.releaseDate.toString();
                  return ListView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: size.width,
                              height: size.height * 0.40 > 300
                                  ? size.height * 0.40
                                  : 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: snapshot.data!.backdropPath == null
                                      ? const AssetImage(
                                              "assets/LoadingImage.png")
                                          as ImageProvider
                                      : NetworkImage(
                                          "https://image.tmdb.org/t/p/original${snapshot.data!.backdropPath}",
                                        ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width,
                              height: size.height * 0.40 > 300
                                  ? size.height * 0.40
                                  : 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      background_primary.withOpacity(0.50),
                                      background_primary.withOpacity(0.75),
                                      background_primary.withOpacity(0.90),
                                      background_primary.withOpacity(1.00),
                                    ]),
                              ),
                            ),
                            Container(
                              width: size.width,
                              height: size.height * 0.35 > 300
                                  ? size.height * 0.35
                                  : 300,
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    snapshot.data!.voteAverage
                                        .toString()
                                        .substring(0, 3),
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data!.title.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      CircularButtons(
                                        UniconsLine.play,
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          APIService()
                                              .getTrailerLink(
                                                  snapshot.data!.id.toString(),
                                                  "movie")
                                              .then(
                                                  (value) => LaunchUrl(value));
                                        },
                                      ),
                                      if (_user != null)
                                        CircularButtons(
                                          UniconsLine.plus,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            pshowDialog(context, widget.movieId,
                                                "movie");
                                          },
                                        ),
                                      if (_user != null)
                                        CircularButtons(
                                          UniconsLine.ticket,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            pshowDialog(context, widget.movieId,
                                                "movie");
                                          },
                                        ),
                                      Visibility(
                                        visible: snapshot.data!.adult,
                                        child: CircularButtons(
                                          UniconsLine.eighteen_plus,
                                          onTap: () {},
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        FutureBuilder(
                          future: APIService()
                              .getMovieGenres(widget.movieId, "movie"),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 36,
                                width: size.width,
                                margin: const EdgeInsets.only(left: 8),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return TextContainer(
                                        snapshot.data![index].name.toString(),
                                        const EdgeInsets.only(right: 8),
                                        const Color(0xFF14303B));
                                  },
                                ),
                              );
                            } else {
                              return TextContainer(
                                  "Loading",
                                  const EdgeInsets.all(8),
                                  const Color(0xFF14303B));
                            }
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText("Status"),
                            Row(
                              children: [
                                TextContainer(
                                    status,
                                    const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8),
                                    const Color(0xFF382E39)),
                                TextContainer(
                                    "Release: ${releaseDate} ",
                                    const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8),
                                    const Color(0xFF545551)),
                              ],
                            ),
                            TitleText("Overview"),
                            TextContainer(
                                snapshot.data!.overview.toString().isEmpty ||
                                        snapshot.data!.overview.toString() ==
                                            "null"
                                    ? "No overview available"
                                    : snapshot.data!.overview.toString(),
                                const EdgeInsets.all(8),
                                const Color(0xFF0F1D39)),
                            TitleText("Recommendations"),
                            CustomListMovie(recommendedMovies),
                          ],
                        )
                      ]);
                } else {
                  return const LoadingScreen();
                }
              },
            ),
    );
  }
}
