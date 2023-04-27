import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/local/database_helper.dart';
import 'package:restaurant/data/local/preferences_helper.dart';
import 'package:restaurant/screen/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/favorites_restaurant_provider.dart';
import '../data/remote/api_service.dart';
import '../provider/restaurant_list_provider.dart';
import '../provider/scheduling_provider.dart';
import 'favorite_screen.dart';
import 'recommended_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomNavScreen = [
    ChangeNotifierProvider<RestaurantListProvider>(
      create: (_) => RestaurantListProvider(apiService: ApiService()),
      child: const RecommendedScreen(),
    ),
    ChangeNotifierProvider<FavoritesRestaurantProvider>(
      create: (_) =>
          FavoritesRestaurantProvider(databaseHelper: DatabaseHelper()),
      child: const FavoriteScreen(),
    ),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(
          preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance())),
      child: const SettingScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: bottomNavScreen[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black45,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Recommends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
