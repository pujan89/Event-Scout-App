import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void goToEventDetail(BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
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
            ? const Center(
                child: Text('No events added yet'),
              )
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
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => goToEventDetail(context, event),
                    ),
                  );
                },
              ),
      ),
    );
  }
}