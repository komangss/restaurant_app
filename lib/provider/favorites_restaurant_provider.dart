import 'package:flutter/material.dart';
import 'package:restaurant/data/local/database_helper.dart';
import '../models/restaurant.dart';

class FavoritesRestaurantProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  late List<Restaurant> _favoriteRestaurants;
  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;

  late FavoritesRestaurantState _state;
  FavoritesRestaurantState get state => _state;
  void _setState(FavoritesRestaurantState state) {
    _state = state;
    notifyListeners();
  }

  late String _errorMessage;
  String get errorMessage => _errorMessage;
  void _setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    _state = FavoritesRestaurantState.error;
    notifyListeners();
  }

  FavoritesRestaurantProvider({required this.databaseHelper}) {
    getFavoriteRestaurants();
  }

  Future<void> getFavoriteRestaurants() async {
    try {
      _setState(FavoritesRestaurantState.loading);
      final favoriteRestaurants = await databaseHelper.getRestaurants();
      if (favoriteRestaurants.isEmpty) {
        _setState(FavoritesRestaurantState.noData);
      } else {
        _favoriteRestaurants = favoriteRestaurants;
        _setState(FavoritesRestaurantState.hasData);
      }
    } catch (e) {
      _setErrorState(e.toString());
    }
  }

  // Future<void> searchRestaurant(String query) async {
  //   try {
  //     _setState(FavoritesRestaurantState.loading);
  //     final favoriteRestaurants = await databaseHelper.searchRestaurant(query);
  //     if (favoriteRestaurants.restaurants == null) {
  //       _setState(FavoritesRestaurantState.noData);
  //     } else {
  //       _favoriteRestaurants = favoriteRestaurants;
  //       _setState(FavoritesRestaurantState.hasData);
  //     }
  //   } catch (e) {
  //     _setErrorState(e.toString());
  //   }
  // }
}

enum FavoritesRestaurantState { loading, noData, hasData, error }
