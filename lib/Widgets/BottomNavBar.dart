import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/Services/consts.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);
  int currentIndex = 0;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final User? _user = FirebaseAuth.instance.currentUser;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => isAdmin());
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
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: BoxDecoration(
          color: accent_t.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              UniconsLine.home_alt,
              color: widget.currentIndex == 0 ? Colors.white : inactive_accent,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() {
                widget.currentIndex = 0;
              });
              GoRouter.of(context).go('/main');
            },
          ),
          IconButton(
            icon: Icon(
              UniconsLine.search,
              color: widget.currentIndex == 1 ? Colors.white : inactive_accent,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() {
                widget.currentIndex = 1;
              });
              GoRouter.of(context).go('/search');
            },
          ),
          if (_user != null)
            IconButton(
              icon: Icon(
                UniconsLine.heart,
                color:
                    widget.currentIndex == 2 ? Colors.white : inactive_accent,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  widget.currentIndex = 2;
                });
                GoRouter.of(context).go('/profile');
              },
            ),
          if (isVisible)
            IconButton(
              icon: Icon(
                UniconsLine.plus,
                color:
                    widget.currentIndex == 3 ? Colors.white : inactive_accent,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  widget.currentIndex = 3;
                });
                GoRouter.of(context).go('/create-film');
              },
            )
        ],
      ),
    );
  }
}
