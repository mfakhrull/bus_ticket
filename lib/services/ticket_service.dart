import 'package:sqflite/sqflite.dart';
import 'package:murni_bus_ticket/models/ticket.dart';
import 'package:murni_bus_ticket/services/database_service.dart';
import 'dart:math';

class TicketService {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Ticket>> getBookings(int userId) async {
    final db = await _dbService.db;
    final List<Map<String, dynamic>> result =
        await db.query('busticket', where: 'user_id = ?', whereArgs: [userId]);
    return result.map((map) => Ticket.fromMap(map)).toList();
  }

  Future<void> saveTicket(Ticket ticket) async {
    final db = await _dbService.db;
    await db.insert('busticket', ticket.toMap());
  }

  Future<void> updateBooking(Ticket ticket) async {
    final db = await _dbService.db;
    await db.update('busticket', ticket.toMap(),
        where: 'book_id = ?', whereArgs: [ticket.bookId]);
  }

  Future<void> confirmBooking(int bookId) async {
    // In our current design, a ticket becomes 'confirmed' when it's saved in the database.
    // So this method might not be needed. Alternatively, you might update some status field here.
  }

  Future<void> cancelBooking(int bookId) async {
    final db = await _dbService.db;
    // We're assuming that 'cancelling' a ticket means removing it from the database.
    await db.delete('busticket', where: 'book_id = ?', whereArgs: [bookId]);
  }

  int generateBookId() {
    var rng = new Random();
    return rng.nextInt(900000) +
        100000; // generates a random number between 100000 and 999999
  }

  // In TicketService
  Future<Ticket> getLatestBooking(int userId) async {
    final db = await _dbService.db;
    final List<Map<String, dynamic>> result = await db.query(
      'busticket',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'book_id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Ticket.fromMap(result.first);
    }
    throw Exception("No ticket found");
  }
}
