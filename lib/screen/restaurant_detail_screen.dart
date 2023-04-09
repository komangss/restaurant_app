import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/restaurant_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class RestaurantDetailScreen extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
        builder: (context, restaurantDetailProvider, child) {
      switch (restaurantDetailProvider.state) {
        case GetRestaurantDetailState.loading:
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        case GetRestaurantDetailState.noData:
          return Scaffold(
            appBar: AppBar(
              title: Text('Empty'),
            ),
            body: const Center(
              child: Text('the detail data is empty'),
            ),
          );
        case GetRestaurantDetailState.hasData:
          var restaurant =
              restaurantDetailProvider.restaurantDetailResponse.restaurant!;
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
                              child: _buildHomeImage(restaurant.pictureId)),
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
        case GetRestaurantDetailState.error:
          return Scaffold(
            appBar: AppBar(
              title: Text('Restaurant Details'),
            ),
            body: const Center(
              child: Text('the detail data is empty'),
            ),
          );

        default:
          return Scaffold(
            appBar: AppBar(
              title: Text('Restaurant Details'),
            ),
            body: const Center(
              child: Text('the detail data is empty'),
            ),
          );
      }
    });
  }

  SizedBox _buildHomeImage(String? pictureId) {
    return SizedBox(
      width: double.infinity,
      child: Hero(
        tag: pictureId ?? '',
        child: pictureId == null
            ? Container(
                height: 300,
                child: const Placeholder(),
              )
            : Image.network(
                'https://restaurant-api.dicoding.dev/images/medium/${pictureId}',
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, _) =>
                    const Center(child: Icon(Icons.error)),
              ),
      ),
    );
  }

  Column buildRestaurantDetail(Restaurant restaurant, BuildContext context) {
    var drinks = restaurant.menus!.drinks?.map((Category c) => c.name).toList();
    var foods = restaurant.menus!.foods?.map((Category c) => c.name).toList();
    var chipTextStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
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
                .bodyText2
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
