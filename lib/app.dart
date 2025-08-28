import 'package:flutter/material.dart';
import 'app/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      title: 'Fake Store',
      onGenerateRoute: (s) => AppRoutes.onGenerate(s),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
