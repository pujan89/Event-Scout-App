import 'package:flutter/material.dart';
import './admin_eventd_screen.dart';
import './add_event_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
      appBar: AppBar(title: Center(child: Text('Admin Dashboard'))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('Events', '12'),
                _buildCard('Users', '240'),
              ],
            ),

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('Active', '8'),
                _buildCard('Revenue', '\$1200'),
              ],
            ),

            SizedBox(height: 24),

            // 🔹 Recent Events
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  _buildEventItem('Camping Trip', 'Apr 10 - Toronto', context),
                  _buildEventItem('Hiking Event', 'Apr 15 - Waterloo', context),
                ],
              ),
            ),
          ],
        ),
      ),

      // Keep bottom buttons
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

  Widget _buildCard(String title, String value) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(187, 222, 251, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String subtitle, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => goToEventDetail(context),
      ),
    );
  }
}
