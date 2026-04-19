import 'package:flutter/material.dart';
import 'ticket_comp_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  void goToCompare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketComparisonScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = event['image_url'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Event Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Event Banner Image ───────────────────────
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 220,
                        color: Colors.indigo.shade100,
                        child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.indigo),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _imageFallback(),
                  )
                : _imageFallback(),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    event['name'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),

                  SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      Text(event['date'],
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(event['location'],
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Description
                  Text('Description',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),

                  SizedBox(height: 8),

                  Text(event['description'],
                      style: TextStyle(fontSize: 14, color: Colors.grey)),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => goToCompare(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Compare Ticket Prices',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.indigo,
      child: Center(child: Icon(Icons.event, size: 80, color: Colors.white)),
    );
  }
}
