import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Models/PopularMovies.dart';
import 'package:flutter_application_2/Services/API.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:flutter_application_2/Widgets/CustomLists.dart';
import 'package:flutter_application_2/Widgets/LoadingScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_application_2/Services/extraServices.dart';
import 'package:flutter_application_2/Widgets/DetailScreenComponents.dart';

class MovieScreenAdmin extends StatefulWidget {
  MovieScreenAdmin(this.movieId, {super.key});
  String movieId;

  @override
  State<MovieScreenAdmin> createState() => _MovieScreenStateAdmin();
}

class _MovieScreenStateAdmin extends State<MovieScreenAdmin> {
  bool isLoading = true;
  bool isVisible = false;
  late Map<String, dynamic>? movie;

  Future<void> fetchData() async {
    movie = await FireBaseServices().getOneFilm(widget.movieId);
    WidgetsBinding.instance.addPostFrameCallback((_) => isAdmin());
    setState(() {
      isLoading = false;
    });
  }

  void isAdmin() async {
    final role = await FireBaseServices().getUserRole();

    if (role == "Admin") {
      setState(() {
        isVisible = true;
      });
    }
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
              future: FireBaseServices().getOneFilm(widget.movieId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var poster = snapshot.data!['poster'];
                  print(poster);
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
                                  image: poster == null
                                      ? const AssetImage(
                                              "assets/LoadingImage.png")
                                          as ImageProvider
                                      : NetworkImage(poster),
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
                                    snapshot.data!['filmName'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Row(
                                    children: [
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
                                            GoRouter.of(context).push(
                                                '/ticket/${widget.movieId}');
                                          },
                                        ),
                                      if (isVisible)
                                        CircularButtons(
                                          UniconsLine.trash,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            FireBaseServices()
                                                .deleteOneFilm(widget.movieId);
                                            GoRouter.of(context).go('/main');
                                          },
                                        ),
                                      if (isVisible)
                                        CircularButtons(
                                          UniconsLine.pen,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            GoRouter.of(context).push(
                                                '/edit-film/${widget.movieId}');
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText("Overview"),
                            TextContainer(
                                snapshot.data!['description'] == null
                                    ? "No overview available"
                                    : snapshot.data!['description'],
                                const EdgeInsets.all(8),
                                const Color(0xFF0F1D39)),
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
