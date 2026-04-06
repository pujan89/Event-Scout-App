import 'package:flutter/material.dart';
import './add_event_screen.dart';

class AdminEventDetailScreen extends StatelessWidget {
  const AdminEventDetailScreen({super.key});


  void goToEditEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
  }

  void deleteEvent() {
    print('Event Deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Event Details')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Admin Event Detail Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => goToEditEvent(context),
              child: Text('Edit Event'),
            ),
            SizedBox(height: 8),
            FilledButton(
              onPressed: deleteEvent,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete Event'),
            ),
          ],
        ),
      ),
    );
  }
}