import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/restaurant_detail_response.dart';
import 'package:restaurant/models/restaurant_list_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  
  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200 && responseBody['error'] != true) {    
      return RestaurantListResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to load get restaurant list');
    }
  }
  
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200 && responseBody['error'] != true) {    
      return RestaurantDetailResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to load get restaurant $id details');
    }
  }
}