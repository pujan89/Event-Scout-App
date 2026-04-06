// ============================================================
// event_detail_screen.dart
// Developer: Manav Patel
// Description: Shows full details of a selected event.
//              Receives an Event object from HomeScreen via Navigator.
//              "Compare Tickets" navigates to TicketComparisonScreen.
// ============================================================
//
// Course concepts used:
//   Week 2  – Classes (Event properties and methods)
//   Week 3  – Nullable variables, null-aware operators (??)
//   Week 4  – StatelessWidget, Scaffold, AppBar, Column, Text, Icon
//   Week 5  – Row, Padding, SizedBox, Container, BoxDecoration,
//             Expanded, SingleChildScrollView, AspectRatio
//   Week 6  – FilledButton, ElevatedButton, onPressed
//   Week 7  – Navigator.push to TicketComparisonScreen,
//             Navigator.pop to return to HomeScreen
// ============================================================

import 'package:flutter/material.dart';
import '../models/event.dart';
import 'ticket_comp_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // Back arrow auto-calls Navigator.pop (Week 7)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: event.imageUrl.isNotEmpty
                  ? Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: event.location,
                  ),

                  const SizedBox(height: 12),

                  // Date
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: event.date.isNotEmpty ? event.date : 'Date TBD',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: event.time.isNotEmpty ? event.time : 'Time TBD',
                  ),

                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.confirmation_number_rounded,
                    label: 'Starting Price',
                    value: event.price > 0
                        ? '\$${event.price.toStringAsFixed(2)}'
                        : 'Price TBD',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.info_outline_rounded,
                    label: 'Source',
                    value: event.source,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.black12),
                  ),

                  const Text(
                    'About This Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    event.description.isNotEmpty
                        ? event.description
                        : 'No description available for this event.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => goToCompare(context),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Compare Tickets',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.blue.shade700),
        ),

        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.event, size: 64, color: Colors.grey),
      ),
    );
  }
}
