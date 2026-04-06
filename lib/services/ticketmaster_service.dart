// ============================================================
// ticketmaster_service.dart
// Developer: Manav Patel
// Description: Fetches events from the Ticketmaster Discovery API
//              and caches them in the local SQLite database.
// ============================================================
//
// Course concepts used:
//   Week 2  – Classes, Lists, for-in loops
//   Week 3  – Nullable variables, null-aware operators (??)
//   Week 10 – SQLite via sqflite (CRUD operations)
//   Week 12 – HTTP requests, async/await, jsonDecode
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class TicketmasterService {
  static const String _apiKey = 'gNeVLhQy2tkWQGP2I9AasDKpXBm6YYB8';
  static const String _baseUrl =
      'https://app.ticketmaster.com/discovery/v2/events.json';
  static Database? _database;
  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    String path = join(await getDatabasesPath(), 'eventscout.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            name        TEXT,
            location    TEXT,
            date        TEXT,
            time        TEXT,
            description TEXT,
            imageUrl    TEXT,
            category    TEXT,
            price       REAL,
            source      TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<List<Event>> fetchEvents({String city = 'Toronto'}) async {
    try {
      String url = '$_baseUrl?apikey=$_apiKey&city=$city&size=20&sort=date,asc';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final embedded = data['_embedded'];
        if (embedded == null) {
          return await getAllEventsFromDb();
        }

        final List<dynamic> rawEvents = embedded['events'] ?? [];
        List<Event> events = [];
        for (var rawEvent in rawEvents) {
          Event event = _parseTicketmasterEvent(rawEvent);
          events.add(event);
        }
        await saveEventsToDb(events);

        return events;
      } else {
        return await getAllEventsFromDb();
      }
    } catch (e) {
      return await getAllEventsFromDb();
    }
  }

  static Event _parseTicketmasterEvent(Map<String, dynamic> raw) {
    String name = raw['name'] as String? ?? 'Unknown Event';
    String location = 'Unknown Location';
    final embedded = raw['_embedded'] as Map<String, dynamic>?;
    if (embedded != null) {
      final venues = embedded['venues'] as List<dynamic>?;
      if (venues != null && venues.isNotEmpty) {
        final venue = venues[0] as Map<String, dynamic>;
        String venueName = venue['name'] as String? ?? '';
        String city = '';
        final cityMap = venue['city'] as Map<String, dynamic>?;
        if (cityMap != null) {
          city = cityMap['name'] as String? ?? '';
        }
        location = venueName.isNotEmpty ? '$venueName, $city' : city;
      }
    }

    String date = '';
    String time = '';
    final dates = raw['dates'] as Map<String, dynamic>?;
    if (dates != null) {
      final start = dates['start'] as Map<String, dynamic>?;
      if (start != null) {
        date = start['localDate'] as String? ?? '';
        time = start['localTime'] as String? ?? '';
      }
    }

    String imageUrl = '';
    final images = raw['images'] as List<dynamic>?;
    if (images != null && images.isNotEmpty) {
      for (var img in images) {
        String ratio = img['ratio'] as String? ?? '';
        if (ratio == '16_9') {
          imageUrl = img['url'] as String? ?? '';
          break;
        }
      }

      if (imageUrl.isEmpty) {
        imageUrl = images[0]['url'] as String? ?? '';
      }
    }

    String category = '';
    final classifications = raw['classifications'] as List<dynamic>?;
    if (classifications != null && classifications.isNotEmpty) {
      final segment = classifications[0]['segment'] as Map<String, dynamic>?;
      if (segment != null) {
        category = segment['name'] as String? ?? '';
      }
    }

    double price = 0.0;
    final priceRanges = raw['priceRanges'] as List<dynamic>?;
    if (priceRanges != null && priceRanges.isNotEmpty) {
      price = (priceRanges[0]['min'] as num?)?.toDouble() ?? 0.0;
    }

    String description =
        raw['info'] as String? ??
        raw['pleaseNote'] as String? ??
        'No description available.';

    return Event(
      name: name,
      location: location,
      date: date,
      time: time,
      description: description,
      imageUrl: imageUrl,
      category: category,
      price: price,
      source: 'Ticketmaster',
    );
  }

  static Future<List<Event>> getAllEventsFromDb() async {
    Database db = await getDatabase();
    String sql = 'SELECT * FROM events';
    List<Map<String, dynamic>> rows = await db.rawQuery(sql);

    List<Event> events = [];
    for (var row in rows) {
      events.add(Event.fromMap(row));
    }
    return events;
  }

  static Future<void> saveEventsToDb(List<Event> events) async {
    Database db = await getDatabase();
    await db.rawDelete('DELETE FROM events');
    for (Event event in events) {
      await db.rawInsert(
        '''INSERT INTO events
           (name, location, date, time, description, imageUrl, category, price, source)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
        [
          event.name,
          event.location,
          event.date,
          event.time,
          event.description,
          event.imageUrl,
          event.category,
          event.price,
          event.source,
        ],
      );
    }
  }

  static Future<List<Event>> searchEventsInDb(String query) async {
    Database db = await getDatabase();
    String sql = "SELECT * FROM events WHERE name LIKE ? OR location LIKE ?";
    String pattern = '%$query%';
    List<Map<String, dynamic>> rows = await db.rawQuery(sql, [
      pattern,
      pattern,
    ]);

    List<Event> results = [];
    for (var row in rows) {
      results.add(Event.fromMap(row));
    }
    return results;
  }
}
