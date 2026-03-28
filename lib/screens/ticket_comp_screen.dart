import 'package:flutter/material.dart';
import './payment_screen.dart';

class TicketComparisonScreen extends StatelessWidget {

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Compare Tickets')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Ticket Comparison Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToPayment(context),
          child: Text('Select Ticket'),
        ),
      ),
    );
  }
}