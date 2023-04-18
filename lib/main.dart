import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/local/database_helper.dart';
import 'package:restaurant/provider/favorite_restaurant_detail_provider.dart';
import 'package:restaurant/provider/restaurant_detail_provider.dart';
import 'package:restaurant/screen/favorite_restaurant_detail_screen.dart';
import 'package:restaurant/screen/restaurant_detail_screen.dart';
import '/styles/typhography.dart';

import 'data/remote/api_service.dart';
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
      theme: ThemeData(
          textTheme: mainTextTheme,
          appBarTheme: appBarTheme,
          splashColor: Colors.black),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        RestaurantDetailScreen.routeName: (context) =>
            ChangeNotifierProvider<RestaurantDetailProvider>(
              create: (_) => RestaurantDetailProvider(
                  apiService: ApiService(),
                  databaseHelper: DatabaseHelper(),
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String),
              child: const RestaurantDetailScreen(),
            ),
        FavoriteRestaurantDetailScreen.routeName: (context) =>
            ChangeNotifierProvider<FavoriteRestaurantDetailProvider>(
              create: (_) => FavoriteRestaurantDetailProvider(
                  databaseHelper: DatabaseHelper(),
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String),
              child: const FavoriteRestaurantDetailScreen(),
            ),
      },
    );
  }
}
