// To parse this JSON data, do
//
//     final restaurantListResponse = restaurantListResponseFromJson(jsonString);

import 'dart:convert';

import 'restaurant.dart';

RestaurantListResponse restaurantListResponseFromJson(String str) => RestaurantListResponse.fromJson(json.decode(str));

class RestaurantListResponse {
    RestaurantListResponse({
        this.error,
        this.message,
        this.count,
        this.founded,
        this.restaurants,
    });

    bool? error;
    String? message;
    int? count;
    int? founded;
    List<Restaurant>? restaurants;

    factory RestaurantListResponse.fromJson(Map<String, dynamic> json) => RestaurantListResponse(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        founded: json["founded"],
        restaurants: json["restaurants"] == null ? [] : List<Restaurant>.from(json["restaurants"]!.map((x) => Restaurant.fromJson(x))),
    );
}
