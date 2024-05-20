import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<bool> doesUserExist() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Data')
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> startCollection() async {
    bool condition = await doesUserExist();
    if (condition == false) {
      FirebaseFirestore.instance
          .collection("Data")
          .doc(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .set({
        "Email": FirebaseAuth.instance.currentUser!.email,
        "WatchList": [],
        "ticket": [],
        "Role": "User"
      });
    }
  }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      startCollection();
    });

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
  }
}

class FireBaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWatching(String id, String status, String mediaType) async {
    List watchlist = await _firestore
        .collection("Data")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!["WatchList"]);
    for (var i = 0; i < watchlist.length; i++) {
      if (watchlist[i]["Id"] == id) {
        await _firestore
            .collection("Data")
            .doc(_auth.currentUser!.uid)
            .update({
              "WatchList": FieldValue.arrayRemove([
                {
                  "Id": id,
                  "status": watchlist[i]["status"],
                  "mediaType": watchlist[i]["mediaType"],
                }
              ])
            })
            .then((value) {})
            .catchError((error) {});
      }
    }
    await _firestore
        .collection("Data")
        .doc(_auth.currentUser!.uid)
        .update({
          "WatchList": FieldValue.arrayUnion([
            {
              "Id": id,
              "status": status,
              "mediaType": mediaType,
            }
          ])
        })
        .then((value) => {})
        .catchError((error) {});
  }

  Future addTicket(
      String theatre, String filmId, String newPlace, List newTime) async {
    late var timeNum;
    var times = await _firestore
        .collection('Theatre')
        .doc(theatre)
        .collection('Time')
        .get();

    final allData =
        times.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();

    for (var i = 0; i < allData.length; i++) {
      for (var j = 0; j < allData[i]['places'].length; j++) {
        if (allData[i]['places'][j]['place'] == newPlace) {
          timeNum = allData[i]['timeNum'];
          await _firestore
              .collection("Theatre")
              .doc(theatre)
              .collection('Time')
              .doc(allData[i]['id'])
              .update({
                "places": FieldValue.arrayRemove([
                  {"place": newPlace, "isBought": false}
                ])
              })
              .then((value) {})
              .catchError((error) {});

          await _firestore
              .collection("Theatre")
              .doc(theatre)
              .collection('Time')
              .doc(allData[i]['id'])
              .update({
                "places": FieldValue.arrayUnion([
                  {"place": newPlace, "isBought": true}
                ])
              })
              .then((value) {})
              .catchError((error) {});

          await _firestore
              .collection("Data")
              .doc(_auth.currentUser!.uid)
              .update({
                "ticket": FieldValue.arrayUnion([
                  {
                    "theatreId": theatre,
                    "filmId": filmId,
                    "place": newPlace,
                    "time": timeNum
                  }
                ])
              })
              .then((value) => {})
              .catchError((error) {});
        }
      }
    }
  }

  Future<List> getWatchList() async {
    List watchlist = await _firestore
        .collection("Data")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!["WatchList"]);
    return watchlist;
  }

  Future getUserRole() async {
    final role = await _firestore
        .collection('Data')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!['role']);

    return role;
  }

  Future startFilmCollection(Map<String, dynamic> filmData) async {
    return await _firestore.collection('Film').doc().set(filmData);
  }

  Future getFilms() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Film').get();
    final allData = querySnapshot.docs
        .map((doc) => {"id": doc.id, "filmData": doc.data()})
        .toList();
    return allData;
  }

  Future getOneFilm(id) async {
    var documentSnapshot = await _firestore
        .collection('Film')
        .doc(id)
        .get()
        .then((doc) => doc.data());
    return documentSnapshot;
  }

  Future deleteOneFilm(id) async {
    return await _firestore.collection('Film').doc(id).delete();
  }

  Future editFilm(id, filmData) async {
    return await _firestore.collection('Film').doc(id).update({
      "filmName": filmData['filmName'],
      "description": filmData['description'],
      "poster": filmData['poster']
    });
  }

  Future getTheatres() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Theatre').get();
    final allData = querySnapshot.docs
        .map((doc) => {"id": doc.id, "name": doc.data()})
        .toList();
    return allData;
  }

  Future getOneTheatre(id) async {
    var documentSnapshot =
        await _firestore.collection('Theatre').doc(id).collection('Time').get();
    final allTime = documentSnapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();

    return allTime;
  }
}
