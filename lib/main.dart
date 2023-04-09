import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/restaurant_detail_provider.dart';
import 'package:restaurant/provider/restaurant_list_provider.dart';
import 'package:restaurant/screen/restaurant_detail_screen.dart';
import '/styles/typhography.dart';

import 'data/api_service.dart';
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
        HomeScreen.routeName: (context) =>
            ChangeNotifierProvider<RestaurantListProvider>(
              create: (_) => RestaurantListProvider(apiService: ApiService()),
              child: const HomeScreen(),
            ),
        RestaurantDetailScreen.routeName: (context) =>
            ChangeNotifierProvider<RestaurantDetailProvider>(
              create: (_) => RestaurantDetailProvider(
                  apiService: ApiService(),
                  // ToDo: cok kok ada 2 restaurant id
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String),
              child: RestaurantDetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String),
            ),
      },
    );
  }
}
