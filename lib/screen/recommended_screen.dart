import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant/screen/restaurant_detail_screen.dart';

import '../models/restaurant.dart';
import '../provider/restaurant_list_provider.dart';
import '../widget/item_list.dart';
import '../widget/search_text_field.dart';

class RecommendedScreen extends StatelessWidget {
  const RecommendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ..._buildHomeHeader(context),
          _buildSearchInput(context),
          _buildHomeBody(context),
        ],
      ),
    );
  }

  Padding _buildSearchInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SearchTextField(
        hintText: 'Enter a name or location here...',
        onChanged: (value) =>
            Provider.of<RestaurantListProvider>(context, listen: false)
                .searchRestaurant(value),
      ),
    );
  }

  Expanded _buildHomeBody(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Consumer<RestaurantListProvider>(
          builder: (_, restaurantListProvider, __) {
            switch(restaurantListProvider.state) {
                case GetRestaurantListState.loading:
                    return const Center(child: CircularProgressIndicator.adaptive());
                case GetRestaurantListState.noData:
                    return const Center(child: Text('No Data'));
                case GetRestaurantListState.hasData:
                    final List<Restaurant> restaurant =
                  restaurantListProvider.restaurantListResponse.restaurants!;
                    return ListView.builder(
                        itemCount: restaurant.length,
                        itemBuilder: (context, index) {
                                return ItemList(restaurant: restaurant[index], onItemTap: () => Navigator.of(context).pushNamed(
                                    RestaurantDetailScreen.routeName),);
                                },
                    );
                default:
                    return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/sorry.jpg'),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          'Error: ${restaurantListProvider.errorMessage.substring(10)}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          Provider.of<RestaurantListProvider>(context,
                                  listen: false)
                              .fetchRestaurantList();
                        },
                        label: Text(
                          'Refresh',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildHomeHeader(BuildContext context) {
    return [
      Text(
        'Restaurant Apps',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.black),
      ),
      Text(
        'Recommendation restaurant near you!',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ];
  }
}
