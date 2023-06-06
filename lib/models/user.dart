class User {
  int? userId;
  String firstName;
  String lastName;
  String username;
  String password;
  String mobileHp;

  User({
    this.userId,
    this.firstName = '',
    this.lastName = '',
    required this.username,
    required this.password,
    this.mobileHp = '',
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': userId,
      'f_name': firstName,
      'l_name': lastName,
      'username': username,
      'password': password,
      'mobilehp': mobileHp,
    };
    return map;
  }

  // Convert a Map object into a User object
  static User fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      firstName: map['f_name'],
      lastName: map['l_name'],
      username: map['username'],
      password: map['password'],
      mobileHp: map['mobilehp'],
    );
  }
}
