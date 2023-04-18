import 'dart:convert';

class Restaurant {
  Restaurant({
    required this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  String id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  List<Category>? categories;
  Menus? menus;
  double? rating;
  List<CustomerReview>? customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    List<Category>? categoriesResult = [];

    if (json["categories"] != null) {
      if (json["categories"] is! String) {
        categoriesResult = (json["categories"] as List<dynamic>)
            .map((e) => Category.fromJson(e))
            .toList();
      } else {
        categoriesResult = jsonDecode(json["categories"]).map<Category>((e) => Category(name: e['name'])).toList();
      }
    }
    List<CustomerReview>? customerReviews = [];
    if (json["customerReviews"] != null && json["customerReviews"] is! String) {
      if (json["customerReviews"] is! String) {
        customerReviews = (json["customerReviews"] as List<dynamic>)
            .map((e) => CustomerReview.fromJson(e))
            .toList();
      } else {
        customerReviews =
        jsonDecode(json["customerReviews"]).map<CustomerReview>((e) => CustomerReview(name: e['name'], date: e['date'], review: e['review'])).toList();
      }
    }
    // Menus menus = json["menus"] == null ? null : Menus.fromJson(json["menus"]);

    double rating = 0.0;
    if(json["rating"] is String) {
      rating = double.parse(json['rating']);
    } else {
      rating = json['rating']?.toDouble();
    }

    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      categories: categoriesResult,
      menus: json["menus"] == null ? null : Menus.fromJson(json["menus"] !is String ? jsonDecode(json["menus"]) : json['menus']),
      rating: rating,
      customerReviews: customerReviews,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": jsonEncode(categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson()))),
        "menus": jsonEncode(menus?.toJson()),
        "rating": rating,
        "customerReviews": jsonEncode(customerReviews == null
            ? []
            : List<dynamic>.from(customerReviews!.map((x) => x.toJson()))),
      };
}

class Category {
  Category({
    required this.name,
  });

  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  String? name;
  String? review;
  String? date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  Menus({
    this.foods,
    this.drinks,
  });

  List<Category>? foods;
  List<Category>? drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: json["foods"] == null
            ? []
            : List<Category>.from(
                json["foods"]!.map((x) => Category.fromJson(x))),
        drinks: json["drinks"] == null
            ? []
            : List<Category>.from(
                json["drinks"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": foods == null
            ? []
            : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "drinks": drinks == null
            ? []
            : List<dynamic>.from(drinks!.map((x) => x.toJson())),
      };
}
