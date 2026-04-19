import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event_model.dart';

class DatabaseHelper {
  static Database? _database;

  static String formatDate(DateTime dt, String time) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} - $time';
  }

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // v5 — added image_url and ticketmaster_price columns
    String path = join(await getDatabasesPath(), 'event_scout_v5.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            role TEXT
          )
        ''');

        // events table with image_url and ticketmaster_price
        await db.execute('''
          CREATE TABLE events(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            location TEXT,
            date TEXT,
            event_date TEXT,
            description TEXT,
            image_url TEXT,
            ticketmaster_price REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE purchased_tickets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_email TEXT,
            event_name TEXT,
            event_date TEXT,
            provider TEXT,
            amount INTEGER,
            booking_id TEXT,
            purchased_at TEXT
          )
        ''');

        await db.insert('users', {
          'name': 'Admin',
          'email': 'admin@gmail.com',
          'password': '1234',
          'role': 'admin',
        });

        DateTime now = DateTime.now();
        DateTime d1 = now.add(Duration(days: 2));
        DateTime d2 = now.add(Duration(days: 30));
        DateTime d3 = now.add(Duration(days: 38));
        DateTime d4 = now.add(Duration(days: 60));
        DateTime d5 = now.add(Duration(days: 90));

        String toYMD(DateTime dt) => dt.toIso8601String().substring(0, 10);

        // Seeded events with different realistic prices per event
        await db.insert('events', {
          'name': 'Spring Music Concert',
          'location': 'Rogers Centre, Toronto',
          'date': formatDate(d1, '7:00 PM'),
          'event_date': toYMD(d1),
          'description':
              'A live outdoor concert featuring top artists. Do not miss it!',
          'image_url':
              'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=800',
          'ticketmaster_price': 95.00,
        });

        await db.insert('events', {
          'name': 'Toronto Music Festival 2026',
          'location': 'Toronto, ON',
          'date': formatDate(d2, '6:00 PM'),
          'event_date': toYMD(d2),
          'description':
              'A fun outdoor music festival featuring top artists and food vendors.',
          'image_url':
              'https://images.unsplash.com/photo-1501612780327-45045538702b?w=800',
          'ticketmaster_price': 75.00,
        });

        await db.insert('events', {
          'name': 'NBA Live Game Night',
          'location': 'Scotiabank Arena',
          'date': formatDate(d3, '7:30 PM'),
          'event_date': toYMD(d3),
          'description': 'Watch your favourite NBA teams battle it out live!',
          'image_url':
              'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
          'ticketmaster_price': 120.00,
        });

        await db.insert('events', {
          'name': 'Modern Art Expo',
          'location': 'Art Gallery of Ontario',
          'date': formatDate(d4, '10:00 AM'),
          'event_date': toYMD(d4),
          'description':
              'Explore stunning contemporary art from local and international artists.',
          'image_url':
              'https://images.unsplash.com/photo-1531243269054-5ebf6f34081e?w=800',
          'ticketmaster_price': 45.00,
        });

        await db.insert('events', {
          'name': 'Summer Night Show',
          'location': 'Budweiser Stage, Toronto',
          'date': formatDate(d5, '8:00 PM'),
          'event_date': toYMD(d5),
          'description':
              'An open-air summer concert with live music, food stalls, and great vibes.',
          'image_url':
              'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
          'ticketmaster_price': 85.00,
        });
      },
    );

    return _database!;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  static Future<bool> registerUser(
      String name, String email, String password) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> existing =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) return false;
    await db.insert('users',
        {'name': name, 'email': email, 'password': password, 'role': 'user'});
    return true;
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isNotEmpty) return result[0];
    return null;
  }

  static Future<List<Map<String, dynamic>>> getUpcomingEvents() async {
    Database db = await getDatabase();
    String today = DateTime.now().toIso8601String().substring(0, 10);
    String twoDays = DateTime.now()
        .add(Duration(days: 2))
        .toIso8601String()
        .substring(0, 10);
    return await db.query('events',
        where: 'event_date >= ? AND event_date <= ?',
        whereArgs: [today, twoDays]);
  }

  static Future<void> insertEvent(EventModel event) async {
    Database db = await getDatabase();
    await db.insert('events', event.toMap());
  }

  static Future<List<Map<String, dynamic>>> getEvents() async {
    Database db = await getDatabase();
    return await db.query('events');
  }

  static Future<void> updateEvent(int id, String name, String location,
      String date, String description) async {
    Database db = await getDatabase();
    await db.update(
        'events',
        {
          'name': name,
          'location': location,
          'date': date,
          'description': description
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  static Future<void> deleteEvent(int id) async {
    Database db = await getDatabase();
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> savePurchasedTicket({
    required String userEmail,
    required String eventName,
    required String eventDate,
    required String provider,
    required int amount,
    required String bookingId,
  }) async {
    Database db = await getDatabase();
    String purchasedAt = DateTime.now().toIso8601String().substring(0, 10);
    await db.insert('purchased_tickets', {
      'user_email': userEmail,
      'event_name': eventName,
      'event_date': eventDate,
      'provider': provider,
      'amount': amount,
      'booking_id': bookingId,
      'purchased_at': purchasedAt,
    });
  }

  static Future<List<Map<String, dynamic>>> getPurchasedTickets(
      String userEmail) async {
    Database db = await getDatabase();
    return await db.query('purchased_tickets',
        where: 'user_email = ?', whereArgs: [userEmail], orderBy: 'id DESC');
  }
}
