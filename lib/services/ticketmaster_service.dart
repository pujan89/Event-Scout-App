import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

class TicketmasterService {
  static const String _apiKey = 'gNeVLhQy2tkWQGP2I9AasDKpXBm6YYB8';
  static const String _baseUrl =
      'https://app.ticketmaster.com/discovery/v2/events.json';

  static Future<void> fetchAndSaveEvents({String city = 'Toronto'}) async {
    try {
      String url = '$_baseUrl?apikey=$_apiKey&city=$city&size=10&sort=date,asc';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final embedded = data['_embedded'] as Map<String, dynamic>?;
        if (embedded == null) return;

        final List<dynamic> rawEvents = embedded['events'] ?? [];
        if (rawEvents.isEmpty) return;

        await _clearApiEvents();

        for (var raw in rawEvents) {
          Map<String, dynamic>? eventMap = _parseEvent(raw);
          if (eventMap != null) {
            final db = await DatabaseHelper.getDatabase();
            await db.insert('events', eventMap);
          }
        }
      }
    } catch (e) {
      // Silently fail — seeded events still show
    }
  }

  static Map<String, dynamic>? _parseEvent(Map<String, dynamic> raw) {
    try {
      String name = raw['name'] as String? ?? 'Unknown Event';

      // Location
      String location = 'Toronto, ON';
      final emb = raw['_embedded'] as Map<String, dynamic>?;
      if (emb != null) {
        final venues = emb['venues'] as List<dynamic>?;
        if (venues != null && venues.isNotEmpty) {
          final venue = venues[0] as Map<String, dynamic>;
          String venueName = venue['name'] as String? ?? '';
          String city = '';
          final cityMap = venue['city'] as Map<String, dynamic>?;
          if (cityMap != null) city = cityMap['name'] as String? ?? '';
          if (venueName.isNotEmpty && city.isNotEmpty) {
            location = '$venueName, $city';
          } else if (city.isNotEmpty) {
            location = city;
          }
        }
      }

      // Date
      String displayDate = 'Date TBD';
      String eventDate = '';
      final dates = raw['dates'] as Map<String, dynamic>?;
      if (dates != null) {
        final start = dates['start'] as Map<String, dynamic>?;
        if (start != null) {
          eventDate = start['localDate'] as String? ?? '';
          String localTime = start['localTime'] as String? ?? '';
          if (eventDate.isNotEmpty) {
            try {
              DateTime dt = DateTime.parse(eventDate);
              String timeStr = _formatTime(localTime);
              displayDate = DatabaseHelper.formatDate(dt, timeStr);
            } catch (_) {
              displayDate = eventDate;
            }
          }
        }
      }

      // Image — prefer 16:9
      String imageUrl = '';
      final images = raw['images'] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          if ((img['ratio'] as String? ?? '') == '16_9') {
            imageUrl = img['url'] as String? ?? '';
            break;
          }
        }
        if (imageUrl.isEmpty) imageUrl = images[0]['url'] as String? ?? '';
      }

      // ── Real price from Ticketmaster priceRanges ──────────
      double ticketmasterPrice = 0.0;
      final priceRanges = raw['priceRanges'] as List<dynamic>?;
      if (priceRanges != null && priceRanges.isNotEmpty) {
        ticketmasterPrice = (priceRanges[0]['min'] as num?)?.toDouble() ?? 0.0;
      }

      String description = raw['info'] as String? ??
          raw['pleaseNote'] as String? ??
          'No description available.';

      return {
        'name': name,
        'location': location,
        'date': displayDate,
        'event_date': eventDate,
        'description': description,
        'image_url': imageUrl,
        'ticketmaster_price': ticketmasterPrice,
      };
    } catch (_) {
      return null;
    }
  }

  static String _formatTime(String localTime) {
    if (localTime.isEmpty) return '8:00 PM';
    try {
      List<String> parts = localTime.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return '8:00 PM';
    }
  }

  static Future<void> _clearApiEvents() async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete('events', where: 'id > ?', whereArgs: [5]);
  }
}
