import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/restaurant_detail_response.dart';
import 'package:restaurant/models/restaurant_list_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));
      var responseBody = json.decode(response.body);
      return RestaurantListResponse.fromJson(responseBody);
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
      var responseBody = json.decode(response.body);
      return RestaurantDetailResponse.fromJson(responseBody);
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }

  Future<RestaurantListResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    var responseBody = json.decode(response.body);
    return RestaurantListResponse.fromJson(responseBody);
  }
}
