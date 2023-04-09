import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant_list_response.dart';
import '../data/api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchRestaurantList();
  }

  Future<void> _fetchRestaurantList() async {
    try {
      _state = GetRestaurantListState.loading;
      notifyListeners();
      final getRestaurantListResult = await apiService.getRestaurantList();
      if (getRestaurantListResult.restaurants == null) {
        _state = GetRestaurantListState.noData;
        notifyListeners();
      } else {
        _state = GetRestaurantListState.hasData;
        notifyListeners();
        _restaurantListResponse = getRestaurantListResult;
      }
    } catch (e) {
      _state = GetRestaurantListState.error;
      notifyListeners();
    }
  }

  late RestaurantListResponse _restaurantListResponse;
  RestaurantListResponse get restaurantListResponse => _restaurantListResponse;

  late GetRestaurantListState _state;
  GetRestaurantListState get state => _state;
}

enum GetRestaurantListState { loading, noData, hasData, error }
