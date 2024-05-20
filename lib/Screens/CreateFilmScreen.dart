import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:flutter_application_2/Widgets/BottomNavBar.dart';

class CreateFilmScreen extends StatefulWidget {
  const CreateFilmScreen({super.key});

  @override
  State<CreateFilmScreen> createState() => _CreateFilmScreenState();
}

class _CreateFilmScreenState extends State<CreateFilmScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool _validate = false;
  bool _validateDesc = false;
  bool _validatePoster = false;

  TextEditingController filmNameController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController PosterContoller = new TextEditingController();

  uploadData() async {
    if (_validate == false &&
        _validateDesc == false &&
        _validatePoster == false) {
      Map<String, dynamic> uploadData = {
        "filmName": filmNameController.text,
        "description": DescriptionController.text,
        "poster": PosterContoller.text
      };

      await FireBaseServices().startFilmCollection(uploadData);
    }
  }

  String? filmName;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
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
                        errorText: _validate ? "Value can't be empty" : null),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: DescriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        errorText:
                            _validateDesc ? "Value can't be empty" : null),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: PosterContoller,
                    decoration: InputDecoration(
                        labelText: 'Poster link',
                        errorText:
                            _validatePoster ? "Value can't be empty" : null),
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
                      uploadData();
                    },
                    label: const Text(
                      'Create film',
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
