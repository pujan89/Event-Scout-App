import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class AdminEventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const AdminEventDetailScreen({super.key, required this.event});

  @override
  State<AdminEventDetailScreen> createState() => _AdminEventDetailScreenState();
}

class _AdminEventDetailScreenState extends State<AdminEventDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController descriptionController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event['name']);
    locationController = TextEditingController(text: widget.event['location']);
    dateController = TextEditingController(text: widget.event['date']);
    descriptionController = TextEditingController(text: widget.event['description']);
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void saveChanges() async {
    await DatabaseHelper.updateEvent(
      widget.event['id'],
      nameController.text.trim(),
      locationController.text.trim(),
      dateController.text.trim(),
      descriptionController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event updated successfully!')),
    );

    setState(() {
      isEditing = false;
    });

    Navigator.pop(context);
  }

  void showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEvent();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteEvent() async {
    await DatabaseHelper.deleteEvent(widget.event['id']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Event Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Banner
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  isEditing
                      ? TextField(
                          controller: nameController,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : Text(
                          nameController.text,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                  SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      isEditing
                          ? Expanded(
                              child: TextField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            )
                          : Text(
                              dateController.text,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      isEditing
                          ? Expanded(
                              child: TextField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            )
                          : Text(
                              locationController.text,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),

                  SizedBox(height: 6),

                  isEditing
                      ? TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : Text(
                          descriptionController.text,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                  SizedBox(height: 24),

                  // Edit / Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isEditing ? saveChanges : startEditing,
                      icon: Icon(
                        isEditing ? Icons.save : Icons.edit,
                        color: Colors.indigo,
                        size: 18,
                      ),
                      label: Text(
                        isEditing ? 'Save Changes' : 'Edit Event',
                        style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.indigo),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: showDeleteConfirmation,
                      icon: Icon(Icons.delete, color: Colors.red, size: 18),
                      label: Text(
                        'Delete Event',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
