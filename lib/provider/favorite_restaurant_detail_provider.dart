import 'package:flutter/material.dart';
import 'package:restaurant/data/local/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteRestaurantDetailProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  final String restaurantId;

  FavoriteRestaurantDetailProvider({
    required this.restaurantId,
    required this.databaseHelper,
  }) {
    getFavRestaurantFromDB(restaurantId);
  }

  late Restaurant _restaurant;
  Restaurant get restaurant => _restaurant;

  late GetFavoriteRestaurantDetailState _state;
  GetFavoriteRestaurantDetailState get state => _state;
  void _setState(GetFavoriteRestaurantDetailState state) {
    _state = state;
    notifyListeners();
  }

  late String _errorMessage;
  String get errorMessage => _errorMessage;
  void _setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    _state = GetFavoriteRestaurantDetailState.error;
    notifyListeners();
  }

  bool get isFavoriteRestaurant => _isFavoriteRestaurant;
  late bool _isFavoriteRestaurant;
  void setFavRestaurantStatus(bool isFav) {
    _isFavoriteRestaurant = isFav;
    notifyListeners();
  }

  void setFavRestaurant(Restaurant restaurant) async {
    await databaseHelper.insertRestaurant(restaurant);
    setFavRestaurantStatus(true);
  }

  void removeFavRestaurant(String restaurantId) async {
    await databaseHelper.removeRestaurant(restaurantId);
    setFavRestaurantStatus(false);
  }

  Future<void> getFavRestaurantFromDB(String restaurantId) async {
    try {
      _setState(GetFavoriteRestaurantDetailState.loading);
      var getRestaurantDetailResultDB =
          await databaseHelper.getRestaurantById(restaurantId);
      final getRestaurantDetailResult = Restaurant.fromJson(getRestaurantDetailResultDB as Map<String, dynamic>);
      if (getRestaurantDetailResult.id == '') {
        _setState(GetFavoriteRestaurantDetailState.noData);
      } else {
        setFavRestaurantStatus(true);
        _restaurant = getRestaurantDetailResult;

        _setState(GetFavoriteRestaurantDetailState.hasData);
      }
    } catch (e) {
      _setErrorState(e.toString());
    }
  }
}

enum GetFavoriteRestaurantDetailState { loading, noData, hasData, error }
