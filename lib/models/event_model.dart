class EventModel {
  int? id;
  String name;
  String location;
  String date;
  String description;

  EventModel({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'description': description,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      description: map['description'],
    );
  }
}