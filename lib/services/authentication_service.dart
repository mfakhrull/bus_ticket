import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/models/user.dart';
import 'package:murni_bus_ticket/services/database_service.dart';

class AuthenticationService {
  final DatabaseService _dbService = DatabaseService();

  Future<bool> registerUser(
      String username, String password, String mobileNumber) async {
    // add mobileNumber parameter
    // Create a new User object with mobile number
    User newUser = User(
      username: username,
      password: password,
      mobileHp: mobileNumber, // add mobile number to User constructor
    );

    // Save the user to the database
    bool result = await _dbService.insertUser(newUser);

    return result;
  }

  Future<User?> loginUser(String username, String password) async {
    // Attempt to retrieve the user from the database
    User? user = await _dbService.getUser(username, password);

    // If the user exists and the passwords match, return the user
    if (user != null && user.password == password) {
      return user;
    }

    // If the user doesn't exist or the passwords don't match, return null
    return null;
  }

  Future<void> logoutUser(BuildContext context) async {
    // Clear the user session or perform any necessary logout operations
    // For example, you can delete any stored user data or tokens

    // Navigate to the login screen and reset any relevant state
    Navigator.pushReplacementNamed(context, '/');
  }
}
