import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class RestaurantDetailScreen extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.minHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(flex: 2, child: _buildHomeImage()),
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
  }

  SizedBox _buildHomeImage() {
    return SizedBox(
      width: double.infinity,
      child: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            restaurant.pictureId,
            fit: BoxFit.cover,
          )),
    );
  }

  Column buildRestaurantDetail(Restaurant restaurant, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildRatingSection(context),
        ..._buildLocationSection(),
        ..._buildDescriptionSection(),
        ..._buildFoodsSection(context),
        ..._buildDrinksSection(context),
      ],
    );
  }

  List<Widget> _buildRatingSection(BuildContext context) {
    return [
      const Text('Rating:'),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...generateRatingStarIcon(restaurant.rating),
          Text(
            ' ( ${restaurant.rating} )',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black54),
          )
        ],
      ),
    ];
  }

  List<Widget> _buildLocationSection() {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Location:'),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: InkWell(
          onTap: () async =>
              _launchUrl('http://maps.google.com/?q=${restaurant.city}'),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              Text(
                restaurant.city,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildDescriptionSection() {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Descriptions:'),
      ),
      Text(
        restaurant.description,
      ),
    ];
  }

  List<Widget> _buildFoodsSection(BuildContext context) {
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
            ...restaurant.menu.foods.map((foodName) {
              return Chip(
                label: Text(
                  foodName,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 14,
                      ),
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

  List<Widget> _buildDrinksSection(BuildContext context) {
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
              ...restaurant.menu.drinks.map((drinkName) {
                return Chip(
                  label: Text(
                    drinkName,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 14,
                        ),
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
