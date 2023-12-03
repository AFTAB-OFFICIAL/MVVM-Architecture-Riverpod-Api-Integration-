import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api_integration/utils/routes/routing.dart';
import 'package:riverpod_api_integration/view/home_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerDelegate: AppRoute.router.routerDelegate,
      routeInformationProvider: AppRoute.router.routeInformationProvider,
      routeInformationParser: AppRoute.router.routeInformationParser,
    );
  }
}
