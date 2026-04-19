import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

class SeatGeekService {
  static const String _baseUrl = 'https://api.seatgeek.com/2';
  static const String _clientId = '';

  static Future<void> fetchAndStoreEvents(String query) async {
    final url = Uri.parse(
        '$_baseUrl/events?client_id=$_clientId&q=$query&per_page=20');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load events');
    }

    final data = json.decode(response.body);
    List events = data['events'];

    for (var event in events) {
      try {
        if (event['datetime_local'] == null) continue;

        String name = event['title'] ?? 'Unknown Event';

        String location =
            "${event['venue']['name']}, ${event['venue']['city']}";

        DateTime parsedDate = DateTime.parse(event['datetime_local']);

        String eventDate =
            parsedDate.toIso8601String().substring(0, 10);

        String displayDate =
            DatabaseHelper.formatDate(parsedDate, "7:00 PM");

        String description = "Live event from SeatGeek";

        String imageUrl = (event['performers'] != null &&
                event['performers'].isNotEmpty)
            ? event['performers'][0]['image'] ??
                "https://via.placeholder.com/300"
            : "https://via.placeholder.com/300";

        double price = event['stats'] != null &&
                event['stats']['average_price'] != null
            ? (event['stats']['average_price'] as num).toDouble()
            : 50.0;

        bool exists = await DatabaseHelper.eventExists(name, eventDate);

        if (!exists) {
          await DatabaseHelper.saveSeatGeekEvent(
            name: name,
            location: location,
            eventDate: eventDate,
            displayDate: displayDate,
            description: description,
            imageUrl: imageUrl,
            price: price,
          );
        }
      } catch (e) {
        print("SeatGeek parse error: $e");
      }
    }
  }
}