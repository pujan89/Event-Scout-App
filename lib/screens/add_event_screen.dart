import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/database_helper.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void saveEvent(BuildContext context) async {
    String name = nameController.text;
    String location = locationController.text;
    String date = dateController.text;
    String description = descriptionController.text;

    if (name.isEmpty ||
        location.isEmpty ||
        date.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    EventModel newEvent = EventModel(
      name: name,
      location: location,
      date: date,
      description: description,
    );

    await DatabaseHelper.insertEvent(newEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Event saved successfully")),
    );

    nameController.clear();
    locationController.clear();
    dateController.clear();
    descriptionController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Event')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Event Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => saveEvent(context),
          child: Text('Save Event'),
        ),
      ),
    );
  }
}