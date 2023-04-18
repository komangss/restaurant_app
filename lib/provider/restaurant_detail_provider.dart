import 'package:flutter/material.dart';
import 'package:restaurant/data/local/database_helper.dart';
import '../data/remote/api_service.dart';
import '../models/restaurant.dart';
import '../models/restaurant_detail_response.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final DatabaseHelper databaseHelper;

  final String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
    required this.databaseHelper,
  }) {
    fetchRestaurantDetail(restaurantId);
  }

  late RestaurantDetailResponse _restaurantDetailResponse;
  RestaurantDetailResponse get restaurantDetailResponse =>
      _restaurantDetailResponse;

  late GetRestaurantDetailState _state;
  GetRestaurantDetailState get state => _state;
  void _setState(GetRestaurantDetailState state) {
    _state = state;
    notifyListeners();
  }

  late String _errorMessage;
  String get errorMessage => _errorMessage;
  void _setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    _state = GetRestaurantDetailState.error;
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
    var getRestaurantFromDb =
        await databaseHelper.getRestaurantById(restaurantId);
    if (getRestaurantFromDb != null) {
      setFavRestaurantStatus(true);
    } else {
      setFavRestaurantStatus(false);
    }
  }

  Future<void> fetchRestaurantDetail(String restaurantId) async {
    try {
      _setState(GetRestaurantDetailState.loading);
      final getRestaurantDetailResult =
          await apiService.getRestaurantDetail(restaurantId);
      await getFavRestaurantFromDB(restaurantId);
      if (getRestaurantDetailResult.restaurant == null) {
        _setState(GetRestaurantDetailState.noData);
      } else {
        _restaurantDetailResponse = getRestaurantDetailResult;

        _setState(GetRestaurantDetailState.hasData);
      }
    } catch (e) {
      _setErrorState(e.toString());
    }
  }
}

enum GetRestaurantDetailState { loading, noData, hasData, error }
