import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../current_user.dart';

class PurchasedTicketsScreen extends StatefulWidget {
  const PurchasedTicketsScreen({super.key});

  @override
  State<PurchasedTicketsScreen> createState() => _PurchasedTicketsScreenState();
}

class _PurchasedTicketsScreenState extends State<PurchasedTicketsScreen> {
  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  void loadTickets() async {
    tickets = await DatabaseHelper.getPurchasedTickets(CurrentUser.email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Tickets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: tickets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tickets purchased yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Browse events and buy your first ticket!',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return _buildTicketCard(ticket);
                },
              ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigo),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Name
          Row(
            children: [
              Icon(Icons.event, color: Colors.indigo, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  ticket['event_name'] ?? 'Event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),

          // Provider
          _buildTicketRow('Provider', ticket['provider'] ?? ''),
          SizedBox(height: 6),

          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text(
                '\$${ticket['amount']}.00',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),

          // Purchased on
          _buildTicketRow('Purchased On', ticket['purchased_at'] ?? ''),
          SizedBox(height: 10),

          // Booking ID highlighted
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking ID',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  ticket['booking_id'] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(color: Colors.black, fontSize: 13)),
      ],
    );
  }
}
