import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'event_detail_screen.dart';

class AdminEventDetailScreen extends StatefulWidget {
  const AdminEventDetailScreen({super.key});

  @override
  State<AdminEventDetailScreen> createState() => _AdminEventDetailScreenState();
}

class _AdminEventDetailScreenState extends State<AdminEventDetailScreen> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() async {
    events = await DatabaseHelper.getEvents();
    setState(() {});
  }

  void deleteEvent(int id) async {
    await DatabaseHelper.deleteEvent(id);
    loadEvents();
  }

  void goToEventDetail(BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    ).then((_) {
      loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Events')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: events.isEmpty
            ? const Center(child: Text('No events added yet'))
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  return Card(
                    child: ListTile(
                      title: Text(event['name']),
                      subtitle: Text(
                        '${event['location']} - ${event['date']}',
                      ),
                      onTap: () => goToEventDetail(context, event),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteEvent(event['id']),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}