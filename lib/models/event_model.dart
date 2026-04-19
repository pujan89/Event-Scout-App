class EventModel {
  int? id;
  String name;
  String location;
  String date;
  String eventDate; // YYYY-MM-DD format for date comparison
  String description;
  EventModel({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.eventDate,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'event_date': eventDate,
      'description': description,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      eventDate: map['event_date'] ?? '',
      description: map['description'],
    );
  }
}
