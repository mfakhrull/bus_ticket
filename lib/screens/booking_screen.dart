import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/screens/confirmation_screen.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:intl/intl.dart';
import 'package:murni_bus_ticket/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingScreen extends StatefulWidget {
  late Ticket ticket; // Change 'final' to 'late' here
  final User user;

  BookingScreen({required this.user});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TicketService _ticketService = TicketService();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _departureStation;
  late String _destinationStation;
  late String _firstName;
  late String _lastName;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _departureStation = 'Kuala Lumpur';
    _destinationStation = 'Kuala Lumpur';
    _firstName = '';
    _lastName = '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User loggedInUser = widget.user;
      loggedInUser.firstName = _firstName;
      loggedInUser.lastName = _lastName;

      var dbService = DatabaseService();
      bool result = await dbService.updateUser(loggedInUser);
      if (!result) {
        print("Failed to update user's first and last name.");
        // Handle error here
      }

      Ticket newTicket = Ticket(
        bookId: _ticketService.generateBookId(),
        departDate: _selectedDate,
        time: DateFormat.Hm().format(DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedTime.hour,
            _selectedTime.minute)),
        departStation: _departureStation,
        destStation: _destinationStation,
        userId: loggedInUser.userId!,
      );

      await _ticketService
          .saveTicket(newTicket); // Save the ticket in the database

      // Navigate to the ConfirmationScreen, passing the newTicket object
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            ticket: newTicket,
            user: loggedInUser,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departure Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.calendarAlt, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Departure Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.clock, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${_selectedTime.format(context)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Departure Station',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _departureStation,
                  onChanged: (value) {
                    setState(() {
                      _departureStation = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Kuala Lumpur',
                      child: Text('Kuala Lumpur'),
                    ),
                    DropdownMenuItem(
                      value: 'Johor Bahru',
                      child: Text('Johor Bahru'),
                    ),
                    DropdownMenuItem(
                      value: 'Kota Bahru',
                      child: Text('Kota Bahru'),
                    ),
                    DropdownMenuItem(
                      value: 'Alor Setar',
                      child: Text('Alor Setar'),
                    ),
                    DropdownMenuItem(
                      value: 'Melaka',
                      child: Text('Melaka'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Departure Station',
                    prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Destination Station',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _destinationStation,
                  onChanged: (value) {
                    setState(() {
                      _destinationStation = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Kuala Lumpur',
                      child: Text('Kuala Lumpur'),
                    ),
                    DropdownMenuItem(
                      value: 'Johor Bahru',
                      child: Text('Johor Bahru'),
                    ),
                    DropdownMenuItem(
                      value: 'Kota Bahru',
                      child: Text('Kota Bahru'),
                    ),
                    DropdownMenuItem(
                      value: 'Alor Setar',
                      child: Text('Alor Setar'),
                    ),
                    DropdownMenuItem(
                      value: 'Melaka',
                      child: Text('Melaka'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Destination Station',
                    prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First',
                          prefixIcon: Icon(FontAwesomeIcons.user),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last',
                          prefixIcon: Icon(FontAwesomeIcons.user),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _lastName = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
