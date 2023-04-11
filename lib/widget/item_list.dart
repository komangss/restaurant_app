import 'package:flutter/material.dart';

import '../models/restaurant.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.restaurant,
    required this.
  });

  final Restaurant restaurant;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => onNavigationTap(), 
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