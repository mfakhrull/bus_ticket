import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/services/ticket_service.dart';
import 'package:intl/intl.dart';

class UpdateTicketScreen extends StatefulWidget {
  final Ticket ticket;
  final User user;

  UpdateTicketScreen({required this.ticket, required this.user});

  @override
  _UpdateTicketScreenState createState() => _UpdateTicketScreenState();
}

class _UpdateTicketScreenState extends State<UpdateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  late Ticket _ticket;
  late User _user;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TicketService _ticketService = TicketService();

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
    _user = widget.user;
    _selectedDate = _ticket.departDate!;
    _selectedTime = parseTimeString(_ticket.time!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TimeOfDay parseTimeString(String timeString) {
    final format = DateFormat.Hm(); // for format like "09:57"
    final dt = format.parse(timeString);
    return TimeOfDay.fromDateTime(dt);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateTicket() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _ticket.departDate = _selectedDate;
      _ticket.time = _selectedTime.format(context);

      await _ticketService.updateBooking(_ticket);

      Navigator.of(context).pop(_ticket);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Ticket'),
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
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(fontSize: 16),
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
                  child: Text(
                    '${_selectedTime.format(context)}',
                    style: TextStyle(fontSize: 16),
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
                  value: _ticket.departStation,
                  onChanged: (value) {
                    setState(() {
                      _ticket.departStation = value!;
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
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a departure station';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ticket.departStation = value!;
                  },
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
                  value: _ticket.destStation,
                  onChanged: (value) {
                    setState(() {
                      _ticket.destStation = value!;
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
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a destination station';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ticket.destStation = value!;
                  },
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
                        initialValue: _user.firstName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user.firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _user.lastName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user.lastName = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateTicket,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
