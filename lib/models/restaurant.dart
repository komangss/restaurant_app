import 'dart:convert';

import 'menu.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final Menu menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> restaurant) {
    return Restaurant(
      id: restaurant['id'],
      name: restaurant['name'],
      description: restaurant['description'],
      pictureId: restaurant['pictureId'],
      city: restaurant['city'],
      rating: double.parse(restaurant['rating'].toString()),
      menu: Menu.fromJson(restaurant
      ['menus']),
    );
  }
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed2 = jsonDecode(json);
  final List parsed = parsed2["restaurants"];
  return parsed.map((json) => Restaurant.fromJson(json)).toList();
}
