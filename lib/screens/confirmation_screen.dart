import 'package:flutter/material.dart';
import './home_screen.dart';

class ConfirmationScreen extends StatelessWidget {

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    String eventName = "Toronto Music Festival 2026";
    String date = "June 15, 2026 - 6:00 PM";
    String location = "Toronto, ON";
    String provider = "SeatGeek";
    String amount = "\$78.00";
    String bookingId = "ES-2026-4521";

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmed"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your ticket has been confirmed",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Booking Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text("Event: $eventName"),
                  SizedBox(height: 10),

                  Text("Date: $date"),
                  SizedBox(height: 10),

                  Text("Location: $location"),
                  SizedBox(height: 10),

                  Text("Provider: $provider"),
                  SizedBox(height: 10),

                  Text(
                    "Amount: $amount",
                    style: TextStyle(color: Colors.blue),
                  ),

                  SizedBox(height: 10),

                  Divider(),

                  SizedBox(height: 10),

                  Text("Booking ID: $bookingId"),

                ],
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => goToHome(context),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
  ),
),
                child: Text("Back to Home"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}