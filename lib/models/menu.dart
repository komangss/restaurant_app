class Menu {
  final List<String> foods;
  final List<String> drinks;

  Menu(this.foods, this.drinks);

  factory Menu.fromJson(Map<String, dynamic> menus) {
    final List<String> foods = (menus['foods'] as List<dynamic>)
        .map<String>((e) => e['name'])
        .toList();
    final List<String> drinks = (menus['drinks'] as List<dynamic>)
        .map<String>((e) => e['name'])
        .toList();
    return Menu(foods, drinks);
  }
}
