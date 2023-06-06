import 'package:flutter/material.dart';

class Ticket {
  int? bookId;
  DateTime? departDate;
  String? time;
  String? departStation;
  String? destStation;
  int? userId;

  Ticket({
    this.bookId,
    this.departDate,
    this.time,
    this.departStation,
    this.destStation,
    this.userId,
  });

  // Convert a Ticket object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'book_id': bookId,
      'depart_date': departDate?.toIso8601String(),
      'time': time,
      'depart_station': departStation,
      'dest_station': destStation,
      'user_id': userId,
    };
    return map;
  }

  // Convert a Map object into a Ticket object
  static Ticket fromMap(Map<String, dynamic> map) {
    return Ticket(
      bookId: map['book_id'] ?? 0,
      departDate: DateTime.parse(map['depart_date'] ?? ''),
      time: map['time'] ?? '',
      departStation: map['depart_station'] ?? '',
      destStation: map['dest_station'] ?? '',
      userId: map['user_id'] ?? 0,
    );
  }
}
