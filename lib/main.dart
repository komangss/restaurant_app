import 'package:flutter/material.dart';
import 'package:restaurant/screen/restaurant_detail_screen.dart';
import '/models/restaurant.dart';
import '/styles/typhography.dart';

import 'screen/home_screen.dart';
import 'styles/app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(textTheme: mainTextTheme, appBarTheme: appBarTheme),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        RestaurantDetailScreen.routeName: (context) => RestaurantDetailScreen(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant,
            ),
      },
    );
  }
}
