import 'package:flutter/material.dart';
import './ticket_comp_screen.dart';

class EventDetailScreen extends StatelessWidget {

  void goToCompare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TicketComparisonScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Event Details')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Event Detail Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToCompare(context),
          child: Text('Compare Tickets'),
        ),
      ),
    );
  }
}