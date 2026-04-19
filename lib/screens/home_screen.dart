import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/ticketmaster_service.dart';
import '../current_user.dart';
import 'event_detail_screen.dart';
import 'purchased_tickets_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];
  bool _isLoadingApi = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll();
    checkUpcomingEvents();
  }

  Future<void> _loadAll() async {
    await loadEvents();
    setState(() {
      _isLoadingApi = true;
    });
    await TicketmasterService.fetchAndSaveEvents(city: 'Toronto');
    await loadEvents();
    setState(() {
      _isLoadingApi = false;
    });
  }

  Future<void> loadEvents() async {
    allEvents = await DatabaseHelper.getEvents();
    filteredEvents = List.from(allEvents);
    setState(() {});
  }

  void checkUpcomingEvents() async {
    List<Map<String, dynamic>> upcoming =
        await DatabaseHelper.getUpcomingEvents();
    if (upcoming.isNotEmpty && mounted) {
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.notifications, color: Colors.orange),
                SizedBox(width: 8),
                Text('Event Reminder!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: upcoming.map((event) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('${event['name']} is happening soon!',
                      style: TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it!',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  void searchEvents(String query) {
    if (query.isEmpty) {
      filteredEvents = List.from(allEvents);
    } else {
      filteredEvents = allEvents.where((event) {
        String name = event['name'].toString().toLowerCase();
        String location = event['location'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            location.contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  void goToEventDetail(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
    ).then((_) {
      loadEvents();
    });
  }

  void goToMyTickets() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PurchasedTicketsScreen()),
    );
  }

  void logout() {
    CurrentUser.email = '';
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
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
        automaticallyImplyLeading: false,
        title: Text('Events',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          if (_isLoadingApi)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.blue),
              ),
            ),
          IconButton(
            icon: Icon(Icons.confirmation_number, color: Colors.blue),
            tooltip: 'My Tickets',
            onPressed: goToMyTickets,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: searchEvents,
              decoration: InputDecoration(
                hintText: 'Search Events',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Text('No events found',
                          style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(filteredEvents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    String imageUrl = event['image_url'] as String? ?? '';

    return GestureDetector(
      onTap: () => goToEventDetail(event),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Event Image ──────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Show placeholder while loading
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 150,
                          color: Colors.indigo.shade100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.indigo,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      // Show fallback if image fails
                      errorBuilder: (context, error, stackTrace) =>
                          _imageFallback(),
                    )
                  : _imageFallback(),
            ),

            // ── Event Info ───────────────────────────────
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['name'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(event['location'],
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(event['date'] ?? '',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('From \$75',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.indigo,
      child: Center(child: Icon(Icons.event, size: 60, color: Colors.white)),
    );
  }
}
