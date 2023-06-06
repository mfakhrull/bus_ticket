import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/models/user.dart'; // Import the User model

class HomeScreen extends StatefulWidget {
  final User user; // Add the user object as a parameter

  HomeScreen({required this.user}); // Add the user object to the constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TicketService _ticketService = TicketService();
  Future<List<Ticket>>? _ticketFuture;

  @override
  void initState() {
    super.initState();
    _ticketFuture = _ticketService.getBookings(widget.user.userId ?? 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ticketFuture = _ticketService.getBookings(widget.user.userId ?? 0);
  }

  Future<void> _deleteTicket(int? bookId) async {
    if (bookId != null) {
      await _ticketService.cancelBooking(bookId);
      setState(() {
        _ticketFuture = _ticketService.getBookings(widget.user.userId ?? 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the future has data, display the bookings
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Ticket ticket = snapshot.data![index];
                return ListTile(
                  title: Text('Booking #${ticket.bookId ?? "default"}'),
                  subtitle: Text(
                      '${ticket.departDate ?? DateTime.now()} ${ticket.time ?? "default"} - ${ticket.destStation ?? "default"}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTicket(ticket.bookId),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // If the future has an error, display the error
            return Text('Error: ${snapshot.error}');
          } else {
            // If the future is still loading, display a loading indicator
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the BookingFormScreen when the button is pressed
          Navigator.pushNamed(context, '/booking',
                  arguments: widget.user) // Pass the user object as an argument
              .then((_) {
            // Refresh the list of tickets after the BookingFormScreen is popped
            setState(() {
              _ticketFuture =
                  _ticketService.getBookings(widget.user.userId ?? 0);
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
