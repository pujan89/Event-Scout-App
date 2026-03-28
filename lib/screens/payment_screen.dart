import 'package:flutter/material.dart';
import './confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {

  void goToConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Payment')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Payment Screen')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToConfirmation(context),
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}