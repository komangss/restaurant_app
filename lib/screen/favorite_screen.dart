import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/screen/favorite_restaurant_detail_screen.dart';
import '../provider/favorites_restaurant_provider.dart';

import '../models/restaurant.dart';
import '../widget/item_list.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Consumer<FavoritesRestaurantProvider>(
          builder: (_, restaurantListProvider, __) {
            switch (restaurantListProvider.state) {
              case FavoritesRestaurantState.loading:
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              case FavoritesRestaurantState.noData:
                return const Center(child: Text('No Data'));
              case FavoritesRestaurantState.hasData:
                final List<Restaurant> restaurant =
                    restaurantListProvider.favoriteRestaurants;
                return ListView.builder(
                  itemCount: restaurant.length,
                  itemBuilder: (context, index) {
                    return ItemList(
                      restaurant: restaurant[index],
                      onItemTap: () => Navigator.of(context).pushNamed(
                          FavoriteRestaurantDetailScreen.routeName,
                          arguments: restaurant[index].id)
                        ..then((_) {
                          restaurantListProvider.getFavoriteRestaurants();
                        }),
                    );
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
                            Provider.of<FavoritesRestaurantProvider>(context,
                                    listen: false)
                                .getFavoriteRestaurants();
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
}
