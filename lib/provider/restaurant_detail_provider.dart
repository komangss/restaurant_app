import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../models/restaurant_detail_response.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurantId}) {
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



  Future<void> fetchRestaurantDetail(String restaurantId) async {
    try {
      _setState(GetRestaurantDetailState.loading);
      final getRestaurantDetailResult =
          await apiService.getRestaurantDetail(restaurantId);
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
