import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:flutter_application_2/Widgets/BottomNavBar.dart';
import 'package:collection/collection.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen(this.movieId, {super.key});
  String movieId;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool isLoading = true;

  String? filmName;
  late List Theatres;
  String TheatreId = '';
  late List Times = [];

  late List timeSelected = [];
  late String placeSelected = '';

  Future<void> fetchData() async {
    Theatres = await FireBaseServices().getTheatres();
    setState(() {
      isLoading = false;
    });
  }

  Future fetchTimes(id) async {
    Times = await FireBaseServices().getOneTheatre(id);
  }

  Future getTicket() async {
    if (TheatreId.isNotEmpty &&
        placeSelected.isNotEmpty &&
        timeSelected.isNotEmpty) {
      await FireBaseServices()
          .addTicket(TheatreId, widget.movieId, placeSelected, timeSelected);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(listen);
    _scrollController.dispose();
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
              FutureBuilder(
                  future: FireBaseServices().getTheatres(),
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          style: TextStyle(color: Colors.red),
                          onChanged: (newVal) {
                            setState(() {
                              TheatreId = newVal as String;
                            });
                            fetchTimes(newVal);
                          },
                          items: snapshot.data!
                              .map<DropdownMenuItem<String>>((obj) {
                            return DropdownMenuItem<String>(
                              value: obj['id'],
                              child: Text(obj['name']['name']),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropdownButton(
                            style: TextStyle(color: Colors.red),
                            items: Times.isEmpty
                                ? []
                                : Times.mapIndexed<
                                        DropdownMenuItem<List<dynamic>>>(
                                    (index, timeObj) {
                                    return DropdownMenuItem<List<dynamic>>(
                                      value: timeObj['places'],
                                      child: Text(timeObj['timeNum']),
                                    );
                                  }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                timeSelected = newVal as List;
                              });
                            }),
                        const SizedBox(height: 16),
                        DropdownButton(
                          style: TextStyle(color: Colors.red),
                          items: timeSelected.isEmpty
                              ? []
                              : timeSelected
                                  .map<DropdownMenuItem<String>>((place) {
                                  if (place['isBought'] == false) {
                                    return DropdownMenuItem<String>(
                                        value: place['place'],
                                        child: Text(
                                          place['place'],
                                        ));
                                  }
                                  return const DropdownMenuItem<String>(
                                      value: '',
                                      child: Text(
                                        '',
                                      ));
                                }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              placeSelected = newVal as String;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            getTicket();
                          },
                          label: const Text(
                            'Get ticket',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              backgroundColor: Color(0xFF2A292F)),
                        ),
                      ],
                    );
                  })
            ],
          ),
        )));
  }
}
