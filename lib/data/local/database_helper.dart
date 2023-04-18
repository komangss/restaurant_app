
import 'package:sqflite/sqflite.dart';

import '../../models/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblRestaurant = 'restaurants';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/newsapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblRestaurant (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             city TEXT,
             address TEXT,
             pictureId TEXT,
             categories TEXT,
             menus TEXT,
             rating TEXT,
             customerReviews TEXT
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblRestaurant, restaurant.toJson());
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblRestaurant);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<void> removeRestaurant(String id) async {
    final db = await database;

    await db!.delete(
      _tblRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}