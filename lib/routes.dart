import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screens/CreateFilmScreen.dart';
import 'package:flutter_application_2/Screens/EditFilmScreen.dart';
import 'package:flutter_application_2/Screens/MovieScreenAdmin.dart';
import 'package:flutter_application_2/Screens/TicketScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_2/Screens/LoginScreen.dart';
import 'package:flutter_application_2/Screens/MainScreen.dart';
import 'package:flutter_application_2/Screens/MovieScreen.dart';
import 'package:flutter_application_2/Screens/NavScreen.dart';
import 'package:flutter_application_2/Screens/ProfileScreen.dart';
import 'package:flutter_application_2/Screens/SearchScreen.dart';
import 'package:flutter_application_2/Screens/TvShowScreen.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const NavScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    pageBuilder: defaultPageBuilder<LoginScreen>(const LoginScreen()),
  ),
  GoRoute(
    path: '/main',
    builder: (context, state) => const MainScreen(),
    pageBuilder: defaultPageBuilder<MainScreen>(const MainScreen()),
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchScreen(),
    pageBuilder: defaultPageBuilder<SearchScreen>(const SearchScreen()),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfileScreen(),
    pageBuilder: defaultPageBuilder<ProfileScreen>(const ProfileScreen()),
  ),
  GoRoute(
    path: '/create-film',
    builder: (context, state) => const CreateFilmScreen(),
    pageBuilder: defaultPageBuilder<CreateFilmScreen>(const CreateFilmScreen()),
  ),
  GoRoute(
    path: '/edit-film/:id',
    builder: (context, state) => EditFilmScreen(state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/ticket/:id',
    builder: (context, state) => TicketScreen(state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/movie/:id',
    builder: (context, state) => MovieScreen(state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/movieAdmin/:id',
    builder: (context, state) => MovieScreenAdmin(state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/tv/:id',
    builder: (context, state) => TVShowScreen(state.pathParameters['id']!),
  )
]);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };
