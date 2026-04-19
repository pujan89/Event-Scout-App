import 'dart:math';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../current_user.dart';
import './confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const PaymentScreen({super.key, required this.ticket});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final nameController = TextEditingController();
  final cardController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  String? nameError;
  String? cardError;
  String? expiryError;
  String? cvvError;

  // Generate a random booking ID
  String generateBookingId() {
    int randomNum = Random().nextInt(90000) + 10000;
    return 'ES-${DateTime.now().year}-$randomNum';
  }

  void validateAndPay() async {
    setState(() {
      nameError = null;
      cardError = null;
      expiryError = null;
      cvvError = null;

      // Name check - no numbers allowed
      if (nameController.text.trim().isEmpty ||
          RegExp(r'[0-9]').hasMatch(nameController.text)) {
        nameError = 'Enter valid name (no numbers)';
      }

      // Card check - 16 digits
      if (!RegExp(r'^\d{16}$').hasMatch(cardController.text)) {
        cardError = 'Enter 16-digit card number';
      }

      // Expiry check - MM/YY format
      if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiryController.text)) {
        expiryError = 'Format: MM/YY';
      }

      // CVV check - 3 digits
      if (!RegExp(r'^\d{3}$').hasMatch(cvvController.text)) {
        cvvError = 'Enter 3-digit CVV';
      }
    });

    // If all valid, save and navigate
    if (nameError == null &&
        cardError == null &&
        expiryError == null &&
        cvvError == null) {
      String bookingId = generateBookingId();

      // Save purchased ticket to database
      await DatabaseHelper.savePurchasedTicket(
        userEmail: CurrentUser.email,
        eventName: widget.ticket['eventName'] ?? 'Event',
        eventDate: widget.ticket['eventDate'] ?? '',
        provider: widget.ticket['provider'] ?? '',
        amount: widget.ticket['price'] ?? 0,
        bookingId: bookingId,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            bookingId: bookingId,
            provider: widget.ticket['provider'] ?? '',
            amount: widget.ticket['price'] ?? 0,
            eventName: widget.ticket['eventName'] ?? 'Event',
          ),
        ),
      );
    }
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
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            Text('Full Name', style: TextStyle(fontSize: 14, color: Colors.black)),
            SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Full Name',
                errorText: nameError,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Card Number
            Text('Card Number', style: TextStyle(fontSize: 14, color: Colors.black)),
            SizedBox(height: 6),
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card, color: Colors.grey),
                errorText: cardError,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Expiry + CVV Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiry Date', style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 6),
                      TextField(
                        controller: expiryController,
                        decoration: InputDecoration(
                          hintText: 'Expiry Date',
                          errorText: expiryError,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 6),
                      TextField(
                        controller: cvvController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'CVV',
                          errorText: cvvError,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Total Amount Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '\$${widget.ticket['price']}.00',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: validateAndPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
