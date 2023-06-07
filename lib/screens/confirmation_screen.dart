import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:murni_bus_ticket/screens/view_update_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  late Ticket ticket;
  late User user;

  ConfirmationScreen({required this.ticket, required this.user});

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TicketService _ticketService = TicketService();

  void _confirmBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed!'),
      ),
    );
  }

  void _updateBooking() async {
    final updatedTicket = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTicketScreen(
          ticket: widget.ticket,
          user: widget.user,
        ),
      ),
    );

    if (updatedTicket != null) {
      setState(() {
        widget.ticket = updatedTicket;
      });
    }
  }

  void _cancelBooking() {
    _ticketService.cancelBooking(widget.ticket.bookId ?? 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking cancelled!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Confirm your booking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Booking ID: ${widget.ticket.bookId ?? "N/A"}'),
            Text('Departure Station: ${widget.ticket.departStation ?? "N/A"}'),
            Text('Destination Station: ${widget.ticket.destStation ?? "N/A"}'),
            Text(
                'Departure Date: ${widget.ticket.departDate != null ? DateFormat.yMMMd().format(widget.ticket.departDate!) : "N/A"}'), // New line
            Text('Departure Time: ${widget.ticket.time ?? "N/A"}'), // New line
            SizedBox(height: 20),
            Text(
              'User Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Name: ${widget.user.firstName} ${widget.user.lastName}'),
            Text('Phone: ${widget.user.mobileHp}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmBooking,
              child: Text('Confirm Booking'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _cancelBooking,
              child: Text('Cancel Booking'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateBooking,
              child: Text('Update Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
