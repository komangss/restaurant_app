
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant/models/restaurant_list_response.dart';

import 'dummy_data.dart';

void main() {
  Map<String, dynamic> getRestaurantListResponse = dummyGetRestaurantListResponse;
  group('Restaurant Model', () {
    test(
        'Given JSON contains Restaurants list from Remote Data, Check if the conversion result is matching',
        () {
      var responseBody =
          RestaurantListResponse.fromJson(getRestaurantListResponse);
      List<Map<String, dynamic>> expectation = getRestaurantListResponse['restaurants'];

      expect(expectation[0]['id'], responseBody.restaurants![0].id);
    });
  });
}
