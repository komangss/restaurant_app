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
            _buildSearchInput(context),
            _buildHomeBody(context),
          ],
        ),
      ),
    );
  }

  Padding _buildSearchInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: 'Enter a name or location here...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.black45,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
        onChanged: (value) {
          Provider.of<RestaurantListProvider>(context, listen: false)
              .searchRestaurant(value);
        },
      ),
    );
  }

  Expanded _buildHomeBody(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Consumer<RestaurantListProvider>(
          builder: (_, restaurantListProvider, __) {
            if (restaurantListProvider.state ==
                GetRestaurantListState.loading) {
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
                  ? const SizedBox(
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${restaurant.description}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 2,
            )
          ]),
        ),
      ),
      const Divider(height: 8, thickness: 1.2),
    ]);
  }
}
