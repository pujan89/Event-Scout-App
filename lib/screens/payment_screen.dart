import 'package:flutter/material.dart';
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

  void validateAndPay() {
    setState(() {
      nameError = null;
      cardError = null;
      expiryError = null;
      cvvError = null;

      // Name validation (no numbers allowed)
      if (nameController.text.isEmpty ||
          RegExp(r'[0-9]').hasMatch(nameController.text)) {
        nameError = "Enter valid name (no numbers)";
      }

      // Card validation (16 digits only)
      if (!RegExp(r'^\d{16}$').hasMatch(cardController.text)) {
        cardError = "Enter 16-digit card number";
      }

      // Expiry validation (MM/YY)
      if (!RegExp(
        r'^(0[1-9]|1[0-2])\/\d{2}$',
      ).hasMatch(expiryController.text)) {
        expiryError = "Format MM/YY";
      }

      // CVV validation (3 digits)
      if (!RegExp(r'^\d{3}$').hasMatch(cvvController.text)) {
        cvvError = "Enter 3-digit CVV";
      }

      // If all valid → navigate
      if (nameError == null &&
          cardError == null &&
          expiryError == null &&
          cvvError == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ConfirmationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Payment'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Full Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'John Doe',
                errorText: nameError,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Card Number
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234567890123456',
                errorText: cardError,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Expiry + CVV
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: '12/28',
                      errorText: expiryError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      errorText: cvvError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Total Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Total Amount: \$${widget.ticket['price']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),

      // Pay Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: validateAndPay,
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
