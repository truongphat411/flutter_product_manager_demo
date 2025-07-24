import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/models/models.dart';

class DatabaseService {
  static Database? _database;
  static const _databaseName = 'products.db';
  static const _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      throw Exception('Không khởi tạo được cơ sở dữ liệu: $e');
    }
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE product (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            price INTEGER,
            stockQuantity INTEGER,
            categoryId INTEGER,
            images TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS product (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            price INTEGER,
            stockQuantity INTEGER,
            categoryId INTEGER,
            images TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS category (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<void> resetDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    final path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path);
  }

  Future<void> cacheProduct(List<ProductModel> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        'product',
        {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'stockQuantity': product.stockQuantity,
          'categoryId': product.categoryId,
          'images': jsonEncode(product.images),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<ProductModel>> getCachedProduct({
    String? keyword,
    int? categoryId,
  }) async {
    final db = await database;
    String? where;
    List<dynamic> whereArgs = [];
    if (keyword != null && keyword.isNotEmpty) {
      where = 'name LIKE ?';
      whereArgs.add('%$keyword%');
    }
    if (categoryId != null) {
      where = where != null ? '$where AND categoryId = ?' : 'categoryId = ?';
      whereArgs.add(categoryId);
    }
    try {
      final maps = await db.query(
        'product',
        where: where,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      );
      return maps
          .map((map) => ProductModel(
                id: map['id'] as int,
                name: map['name'] as String,
                description: map['description'] as String,
                price: map['price'] as int,
                stockQuantity: map['stockQuantity'] as int,
                categoryId: map['categoryId'] as int,
                images: List<String>.from(jsonDecode(map['images'] as String)),
              ))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải sản phẩm: $e');
    }
  }

  Future<ProductModel> getProductByID(int id) async {
    final db = await database;
    try {
      final maps = await db.query(
        'product',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) {
        throw Exception('Không tìm thấy sản phẩm có ID');
      }
      final map = maps.first;
      return ProductModel(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        price: map['price'] as int,
        stockQuantity: map['stockQuantity'] as int,
        categoryId: map['categoryId'] as int,
        images: List<String>.from(jsonDecode(map['images'] as String)),
      );
    } catch (e) {
      throw Exception('Không tìm được sản phẩm theo ID: $e');
    }
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final db = await database;
    final batch = db.batch();
    for (var category in categories) {
      batch.insert(
        'category',
        {
          'id': category.id,
          'name': category.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    final db = await database;
    try {
      final maps = await db.query('category');
      return maps
          .map((map) => CategoryModel(
                id: map['id'] as int,
                name: map['name'] as String,
              ))
          .toList();
    } catch (e) {
      throw Exception('Không tìm được danh mục: $e');
    }
  }
}
