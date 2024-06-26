import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_2/Services/auth.dart';
import 'package:flutter_application_2/Services/consts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          color: background_primary,
          child: SafeArea(
              child: Container(
            color: background_primary,
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.3,
                ),
                Lottie.asset(
                  "assets/AuthDuck.json",
                  width: size.width * 0.50,
                  frameRate: FrameRate(60),
                ),
                Center(
                  child: Container(
                      margin: EdgeInsets.all(12),
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        label: Text(
                          sign_in_text,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            backgroundColor: Color(0xFF2A292F)),
                      )),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(24),
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context).go('/main');
                      },
                      label: Text(
                        'Enter as Guest',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Color(0xFF2A292F)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(28, 0, 28, 24),
                  child: Text(
                    footer_text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF423E50)),
                  ),
                )
              ],
            ),
          ))),
    );
  }
}
