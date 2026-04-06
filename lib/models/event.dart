// event.dart
//  Manav Patel

sealed class EventValidationResult {}

class EventValidationSuccess extends EventValidationResult {}

class EventValidationFailure extends EventValidationResult {
  final String message;
  EventValidationFailure(this.message);
}

class Event {
  int? id; // SQLite auto-increment id (nullable – Week 3)
  String name;
  String location;
  String date; // e.g. "Jun 15, 2026"
  String time; // e.g. "7:30 PM"
  String description;
  String imageUrl;
  String category;
  double price;
  String source; // "Ticketmaster"

  Event({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'time': time,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'price': price,
      'source': source,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int?,
      name: map['name'] as String? ?? 'Unknown Event',
      location: map['location'] as String? ?? 'Unknown Location',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      category: map['category'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      source: map['source'] as String? ?? '',
    );
  }

  static EventValidationResult validate({
    required String name,
    required String location,
    required String date,
  }) {
    if (name.trim().isEmpty) {
      return EventValidationFailure('Event name cannot be empty.');
    }
    if (name.trim().length < 3) {
      return EventValidationFailure(
        'Event name must be at least 3 characters.',
      );
    }
    if (location.trim().isEmpty) {
      return EventValidationFailure('Location cannot be empty.');
    }
    if (date.trim().isEmpty) {
      return EventValidationFailure('Date cannot be empty.');
    }
    return EventValidationSuccess();
  }

  @override
  String toString() {
    return 'Event(id: $id, name: $name, location: $location, date: $date)';
  }
}
