import 'package:flutter/material.dart';

class AddEventScreen extends StatelessWidget {
  // Controllers for form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void saveEvent(BuildContext context) {
    print('Event Saved:');
    print('Title: ${titleController.text}');
    print('Description: ${descriptionController.text}');
    print('Location: ${locationController.text}');
    print('Date: ${dateController.text}');

    // Optionally show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event "${titleController.text}" saved!')),
    );

    // Go back after saving
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

              // Event Title
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Description
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),

              // Location
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Date
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  hintText: 'YYYY-MM-DD',
                ),
              ),
              SizedBox(height: 24),
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