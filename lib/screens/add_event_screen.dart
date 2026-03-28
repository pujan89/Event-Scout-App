import 'package:flutter/material.dart';

class AddEventScreen extends StatelessWidget {

  void saveEvent() {
    print('Event Saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Event')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Add Event Form goes here')),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: FilledButton(
          onPressed: saveEvent,
          child: Text('Save Event'),
        ),
      ),
    );
  }
}