import 'package:flutter/material.dart';
import './admin_eventd_screen.dart';
import './add_event_screen.dart';

class AdminDashboardScreen extends StatelessWidget {

  void goToEventDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminEventDetailScreen()),
    );
  }

  void goToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Admin Dashboard')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Admin Dashboard Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => goToEventDetail(context),
              child: Text('View Event'),
            ),
            SizedBox(height: 8),
            FilledButton(
              onPressed: () => goToAddEvent(context),
              child: Text('Add New Event'),
            ),
          ],
        ),
      ),
    );
  }
}