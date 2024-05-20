import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:flutter_application_2/Widgets/BottomNavBar.dart';

class EditFilmScreen extends StatefulWidget {
  EditFilmScreen(this.movieId, {super.key});
  String movieId;

  @override
  State<EditFilmScreen> createState() => _EditFilmScreenState();
}

class _EditFilmScreenState extends State<EditFilmScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool _validate = false;
  bool _validateDesc = false;
  bool _validatePoster = false;
  bool isLoading = true;

  late Map<String, dynamic>? movie;

  TextEditingController filmNameController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController PosterContoller = new TextEditingController();

  editData() async {
    Map<String, dynamic> editData = {
      "filmName": filmNameController.text,
      "description": DescriptionController.text,
      "poster": PosterContoller.text
    };

    await FireBaseServices().editFilm(widget.movieId, editData);
  }

  String? filmName;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
    fetchData();
  }

  Future<void> fetchData() async {
    movie = await FireBaseServices().getOneFilm(widget.movieId);
    filmNameController.text = movie?['filmName'];
    DescriptionController.text = movie?['description'];
    PosterContoller.text = movie?['poster'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(listen);
    _scrollController.dispose();
    filmNameController.dispose();
    DescriptionController.dispose();
    PosterContoller.dispose();
    super.dispose();
  }

  void listen() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      (setState(
        () => isVisible = true,
      ));
    }
  }

  void hide() {
    if (isVisible) {
      (setState(
        () => isVisible = false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AnimatedBuilder(
            animation: _scrollController,
            builder: ((context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                height: isVisible ? 75 : 0,
                child: BottomNavBar(
                  currentIndex: 3,
                ),
              );
            })),
        backgroundColor: background_primary,
        extendBody: true,
        body: Center(
            child: Container(
          child: ListView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(40),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: filmNameController,
                    decoration: InputDecoration(
                      labelText: 'Film name',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: DescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: PosterContoller,
                    decoration: InputDecoration(
                      labelText: 'Poster link',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _validate = filmNameController.text.isEmpty;
                        _validateDesc = DescriptionController.text.isEmpty;
                        _validatePoster = PosterContoller.text.isEmpty;
                      });
                      editData();
                    },
                    label: const Text(
                      'Edit film',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Color(0xFF2A292F)),
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
