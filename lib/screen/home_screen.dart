import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/screen/restaurant_detail_screen.dart';
import '../models/restaurant.dart';
import '../provider/restaurant_list_provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Restaurant App'), ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ..._buildHomeHeader(context),
            _buildHomeBody(context),
          ],
        ),
      ),
    );
  }

  Expanded _buildHomeBody(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Consumer<RestaurantListProvider>(
          builder: (_, restaurantListProvider, __) {
            if (restaurantListProvider.state == GetRestaurantListState.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (restaurantListProvider.state ==
                GetRestaurantListState.noData) {
              return const Center(
                child: Text('No Data'),
              );
            } else if (restaurantListProvider.state ==
                GetRestaurantListState.hasData) {
              final List<Restaurant> restaurant =
                  restaurantListProvider.restaurantListResponse.restaurants!;
              return ListView.builder(
                itemCount: restaurant.length,
                itemBuilder: (context, index) {
                  return ItemList(restaurant: restaurant[index]);
                },
              );
            } else {
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
                          Provider.of<RestaurantListProvider>(context, listen: false).fetchRestaurantList();
                        },
                        label: Text(
                          'Refresh',
                          style: Theme.of(context).textTheme.subtitle2,
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
            .headline4
            ?.copyWith(color: Colors.black),
      ),
      Text(
        'Recommendation restaurant near you!',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ];
  }
}

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            RestaurantDetailScreen.routeName,
            arguments: restaurant.id),
        child: ListTile(
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 85,
              minHeight: 85,
              maxWidth: 85,
              maxHeight: 85,
            ),
            child: Hero(
              tag: restaurant.pictureId ?? '',
              child: restaurant.pictureId == null
                  ? Container(
                      height: 100,
                      child: Placeholder(),
                    )
                  : Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                      width: 100,
                      errorBuilder: (ctx, error, _) =>
                          const Center(child: Icon(Icons.error)),
                    ),
            ),
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              restaurant.name ?? '',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '${restaurant.description}',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 2,
            )
          ]),
        ),
      ),
      Divider(height: 8, thickness: 1.2),
    ]);
  }
}
