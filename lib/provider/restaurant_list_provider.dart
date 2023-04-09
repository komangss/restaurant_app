import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant_list_response.dart';
import '../data/api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  late RestaurantListResponse _restaurantListResponse;
  RestaurantListResponse get restaurantListResponse => _restaurantListResponse;

  late GetRestaurantListState _state;
  GetRestaurantListState get state => _state;
  void _setState(GetRestaurantListState state) {
    _state = state;
    notifyListeners();
  }

  late String _errorMessage;
  String get errorMessage => _errorMessage;
  void _setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    _state = GetRestaurantListState.error;
    notifyListeners();
  }

  RestaurantListProvider({required this.apiService}) {
    fetchRestaurantList();
  }

  Future<void> fetchRestaurantList() async {
    try {
      _setState(GetRestaurantListState.loading);
      final getRestaurantListResult = await apiService.getRestaurantList();
      if (getRestaurantListResult.restaurants == null) {
        _setState(GetRestaurantListState.noData);
      } else {
        _restaurantListResponse = getRestaurantListResult;
        _setState(GetRestaurantListState.hasData);
      }
    } catch (e) {
      _setErrorState(e.toString());
    }
  }
}

enum GetRestaurantListState { loading, noData, hasData, error }
