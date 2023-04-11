import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant/screen/restaurant_detail_screen.dart';

import '../models/restaurant.dart';
import '../provider/restaurant_list_provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomNavScreen = [
    const RecommendedScreen(),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: bottomNavScreen[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black45,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Recommends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
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

class SearchTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;

  const SearchTextField({
    Key? key,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        hintText: hintText,
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
      onChanged: (value) => onChanged(value),
    );
  }
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
