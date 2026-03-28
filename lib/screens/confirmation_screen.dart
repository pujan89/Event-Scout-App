import 'package:flutter/material.dart';
import './home_screen.dart';

class ConfirmationScreen extends StatelessWidget {

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Booking Confirmed')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Confirmation Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToHome(context),
          child: Text('Back to Home'),
        ),
      ),
    );
  }
}