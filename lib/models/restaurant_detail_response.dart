// To parse this JSON data, do
//
//     final restaurantDetailResponse = restaurantDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'restaurant.dart';

RestaurantDetailResponse restaurantDetailResponseFromJson(String str) => RestaurantDetailResponse.fromJson(json.decode(str));

String restaurantDetailResponseToJson(RestaurantDetailResponse data) => json.encode(data.toJson());

class RestaurantDetailResponse {
    RestaurantDetailResponse({
        required this.error,
        required this.message,
        this.restaurant,
    });

    bool error;
    String message;
    Restaurant? restaurant;

    factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) => RestaurantDetailResponse(
        error: json["error"],
        message: json["message"],
        restaurant: json["restaurant"] == null ? null : Restaurant.fromJson(json["restaurant"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant?.toJson(),
    };
}
