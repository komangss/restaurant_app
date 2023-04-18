import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/favorite_restaurant_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class FavoriteRestaurantDetailScreen extends StatelessWidget {
  static const routeName = '/favorite_restaurant_detail';

  const FavoriteRestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteRestaurantDetailProvider>(
        builder: (context, restaurantDetailProvider, child) {
      switch (restaurantDetailProvider.state) {
        case GetFavoriteRestaurantDetailState.loading:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        case GetFavoriteRestaurantDetailState.noData:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Empty'),
            ),
            body: const Center(
              child: Text('the detail data is empty'),
            ),
          );
        case GetFavoriteRestaurantDetailState.hasData:
          var restaurant =
              restaurantDetailProvider.restaurant;
          return Scaffold(
            appBar: AppBar(
              title: Text(restaurant.name ?? ''),
            ),
            body: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.minHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Hero(
                                      tag: restaurant.pictureId ?? '',
                                      child: restaurant.pictureId == null
                                          ? const SizedBox(
                                              height: 300,
                                              child: Placeholder(),
                                            )
                                          : Image.network(
                                              'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (ctx, error, _) =>
                                                  const Center(
                                                      child: Icon(Icons.error)),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 24,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: InkWell(
                                      child: IconButton(
                                        onPressed: () {
                                          restaurantDetailProvider
                                                  .isFavoriteRestaurant
                                              ? restaurantDetailProvider
                                                  .removeFavRestaurant(
                                                      restaurant.id)
                                              : restaurantDetailProvider
                                                  .setFavRestaurant(restaurant);
                                          var snackBar = SnackBar(
                                            content: !restaurantDetailProvider
                                                    .isFavoriteRestaurant
                                                ? const Text(
                                                    'Added to your favorite restaurants!')
                                                : const Text(
                                                    'Removed to your favorite restaurants!'),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          if(restaurantDetailProvider
                                                    .isFavoriteRestaurant
                                          ) {
                                            Navigator.of(context).pop();
                                          }   
                                        },
                                        icon: restaurantDetailProvider
                                                .isFavoriteRestaurant
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.black,
                                              )
                                            : const Icon(
                                                Icons.favorite_border,
                                                color: Colors.black,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(8),
                              child: buildRestaurantDetail(restaurant, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        case GetFavoriteRestaurantDetailState.error:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Restaurant Details'),
            ),
            body: Center(
              child: Text(
                  'Error: ${restaurantDetailProvider.errorMessage.substring(10)}'),
            ),
          );

        default:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Restaurant Details'),
            ),
            body: const Center(
              child: Text('the detail data is empty'),
            ),
          );
      }
    });
  }

  Column buildRestaurantDetail(Restaurant restaurant, BuildContext context) {
    var drinks = restaurant.menus!.drinks?.map((Category c) => c.name).toList();
    var foods = restaurant.menus!.foods?.map((Category c) => c.name).toList();
    var chipTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildRatingSection(context, restaurant.rating),
        ..._buildLocationSection(restaurant.city),
        ..._buildDescriptionSection(restaurant.description),
        ..._buildFoodsSection(foods ?? [], chipTextStyle),
        ..._buildDrinksSection(drinks ?? [], chipTextStyle),
      ],
    );
  }

  List<Widget> _buildRatingSection(BuildContext context, double? rating) {
    return [
      const Text('Rating:'),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...generateRatingStarIcon(rating ?? 0.0),
          Text(
            ' ( $rating )',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black54),
          )
        ],
      ),
    ];
  }

  List<Widget> _buildLocationSection(String? city) {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Location:'),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: InkWell(
          onTap: () async => _launchUrl('http://maps.google.com/?q=$city'),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              Text(
                city ?? 'Unknown',
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildDescriptionSection(String? description) {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Descriptions:'),
      ),
      Text(
        description ?? 'No Description',
      ),
    ];
  }

  List<Widget> _buildFoodsSection(
      List<String> foods, TextStyle? chipTextStyle) {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Foods:'),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Wrap(
          // space between chips
          spacing: 10,
          // list of chips
          children: [
            ...foods.map((foodName) {
              return Chip(
                label: Text(
                  foodName,
                  style: chipTextStyle,
                ),
                avatar: const Icon(Icons.restaurant_menu),
                backgroundColor: Colors.white,
                shape: const StadiumBorder(side: BorderSide()),
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              );
            }).toList(),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildDrinksSection(
      List<String> drinks, TextStyle? chipTextStyle) {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Drinks:'),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Wrap(
            // space between chips
            spacing: 10,
            // list of chips
            children: [
              ...drinks.map((drinkName) {
                return Chip(
                  label: Text(
                    drinkName,
                    style: chipTextStyle,
                  ),
                  avatar: const Icon(Icons.local_drink_rounded),
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder(side: BorderSide()),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                );
              }).toList(),
            ]),
      ),
    ];
  }

  List<Widget> generateRatingStarIcon(double rating) {
    return List.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
      );
    });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
