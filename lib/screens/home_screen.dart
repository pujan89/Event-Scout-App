import 'package:flutter/material.dart';
import './event_detail_screen.dart';

class HomeScreen extends StatelessWidget {

  void goToEventDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Events')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Home Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToEventDetail(context),
          child: Text('View Event'),
        ),
      ),
    );
  }
}