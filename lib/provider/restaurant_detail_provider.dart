import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../models/restaurant_detail_response.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurantId}) {
    _fetchRestaurantDetail(restaurantId);
  }

  Future<void> _fetchRestaurantDetail(String restaurantId) async {
    try {
      _state = GetRestaurantDetailState.loading;
      notifyListeners();
      final getRestaurantDetailResult =
          await apiService.getRestaurantDetail(restaurantId);
      if (getRestaurantDetailResult.restaurant == null) {
        _state = GetRestaurantDetailState.noData;
        notifyListeners();
      } else {
        _state = GetRestaurantDetailState.hasData;
        _restaurantDetailResponse = getRestaurantDetailResult;
        notifyListeners();
      }
    } catch (e) {
      _state = GetRestaurantDetailState.error;
      notifyListeners();
    }
  }

  late RestaurantDetailResponse _restaurantDetailResponse;
  RestaurantDetailResponse get restaurantDetailResponse =>
      _restaurantDetailResponse;

  late GetRestaurantDetailState _state;
  GetRestaurantDetailState get state => _state;
}

enum GetRestaurantDetailState { loading, noData, hasData, error }
