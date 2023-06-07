import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murni_bus_ticket/screens/view_update_screen.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:murni_bus_ticket/services/authentication_service.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/screens/confirmation_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

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

  void _logoutUser(BuildContext context) {
    AuthenticationService authService = AuthenticationService();
    authService.logoutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.bus,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'My Bookings',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logoutUser(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Ticket ticket = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationScreen(
                            ticket: ticket,
                            user: widget.user,
                          ),
                        ),
                      ).then((_) {
                        // Add this
                        setState(() {
                          _ticketFuture = _ticketService
                              .getBookings(widget.user.userId ?? 0);
                        });
                      });
                    },
                    child: ListTile(
                      title: Text(
                        'Booking #${ticket.bookId ?? "default"}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${ticket.departStation ?? "default"} to ${ticket.destStation ?? "default"}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            '${DateFormat.yMMMd().format(ticket.departDate ?? DateTime.now())} ${ticket.time ?? "default"}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTicketScreen(
                                    ticket: ticket,
                                    user: widget.user,
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  _ticketFuture = _ticketService
                                      .getBookings(widget.user.userId ?? 0);
                                });
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteTicket(ticket.bookId),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/booking', arguments: widget.user)
              .then((_) {
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
