import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:murni_bus_ticket/screens/view_update_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  late Ticket ticket;
  late User user; // Add this line

  ConfirmationScreen(
      {required this.ticket, required this.user}); // And modify this line

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TicketService _ticketService = TicketService();
  late Future<Ticket> _ticketFuture;

  @override
  void initState() {
    super.initState();
    _ticketFuture = _ticketService.getLatestBooking(widget.ticket.userId ?? 0);
  }

  void _confirmBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed!'),
      ),
    );
  }

  void _updateBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTicketScreen(
            ticket: widget.ticket, user: widget.user), // Change here
      ),
    ).then((updatedTicket) {
      if (updatedTicket != null) {
        setState(() {
          widget.ticket = updatedTicket;
        });
      }
    });
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
      body: FutureBuilder<Ticket>(
        future: _ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Confirm your booking'),
                  Text('Booking ID: ${snapshot.data!.bookId ?? "N/A"}'),
                  Text(
                      'Departure Station: ${snapshot.data!.departStation ?? "N/A"}'),
                  Text(
                      'Destination Station: ${snapshot.data!.destStation ?? "N/A"}'),
                  SizedBox(height: 10),
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
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
