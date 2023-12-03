import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_api_integration/view/error_view.dart';
import 'package:riverpod_api_integration/view/home_view.dart';
import 'package:riverpod_api_integration/view/login_view.dart';
import 'package:riverpod_api_integration/view/signup_view.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return LoginView();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return HomeViewWidget();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return SignupView();
        },
      ),
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) {
      //     return LoginView();
      //   },
      // )
    ],
    errorBuilder: (context, state) {
      return ErrorView(error: state.error.toString());
    },
  );
}
