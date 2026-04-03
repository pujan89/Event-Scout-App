import 'package:flutter/material.dart';
import './payment_screen.dart';

class TicketComparisonScreen extends StatelessWidget {
  const TicketComparisonScreen({super.key});

  final List<Map<String, dynamic>> tickets = const [
    {"provider": "Ticketmaster", "price": 80},
    {"provider": "SeatGeek", "price": 78},
  ];

  void goToPayment(BuildContext context, Map<String, dynamic> ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen(ticket: ticket)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find lowest price
    double lowestPrice = tickets
        .map((t) => t['price'] as num)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Compare Prices'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: tickets.map((ticket) {
            bool isBest = ticket['price'] == lowestPrice;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isBest ? Colors.blue : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['provider'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "\$${ticket['price']}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 9, 0, 33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => goToPayment(context, ticket),
                          child: const Text("Select"),
                        ),
                      ),
                    ],
                  ),

                  // BEST PRICE LABEL
                  if (isBest)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "BEST PRICE",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
