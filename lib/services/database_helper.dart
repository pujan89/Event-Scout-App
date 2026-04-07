import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event_model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    String path = join(await getDatabasesPath(), 'event_scout.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT,
            role TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE events(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            location TEXT,
            date TEXT,
            description TEXT
          )
        ''');

        await db.insert('users', {
          'email': 'admin@gmail.com',
          'password': '1234',
          'role': 'admin',
        });
      },
    );

    return _database!;
  }

  static Future<Map<String, dynamic>?> loginAdmin(
    String email,
    String password,
  ) async {
    Database db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ? AND role = ?',
      whereArgs: [email, password, 'admin'],
    );

    if (result.isNotEmpty) {
      return result[0];
    }

    return null;
  }

  static Future<void> insertEvent(EventModel event) async {
    Database db = await getDatabase();
    await db.insert('events', event.toMap());
  }

  static Future<List<Map<String, dynamic>>> getEvents() async {
    Database db = await getDatabase();
    return await db.query('events');
  }

  static Future<void> deleteEvent(int id) async {
    Database db = await getDatabase();
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}