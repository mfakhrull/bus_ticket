import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:murni_bus_ticket/models/user.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'busservices.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    // Check if the index already exists before creating it
    bool indexExists = await _indexExists(database, 'busticket', 'idx_user_id');
    if (!indexExists) {
      await database.execute('CREATE INDEX idx_user_id ON busticket(user_id)');
    }

    return database;
  }

  Future<bool> _indexExists(
      Database database, String table, String index) async {
    var result = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = '$table' AND name = '$index'",
    );
    return result.isNotEmpty;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE `user` (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      f_name TEXT NOT NULL,
      l_name TEXT NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      mobilehp TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE busticket (
      book_id INTEGER PRIMARY KEY AUTOINCREMENT,
      depart_date DATE NOT NULL,
      time TIME NOT NULL,
      depart_station TEXT NOT NULL,
      dest_station TEXT NOT NULL,
      user_id INTEGER NOT NULL
    )
  ''');

    // Create an index for the user_id column in the busticket table if it doesn't exist
    try {
      await db.execute('CREATE INDEX idx_user_id ON busticket(user_id)');
    } catch (e) {
      print('Index creation failed: $e');
    }
  }

  Future<bool> insertUser(User user) async {
    final db = await this.db;
    var data = user.toMap();
    try {
      await db.insert(
        'user',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (error) {
      // You might want to handle the error or/and log it.
      print('Failed to insert user: $error');
      return false;
    }
  }

  Future<User?> getUser(String username, String password) async {
    final db = await this.db;
    var res = await db.rawQuery('''
    SELECT *
    FROM `user`
    WHERE username = ? AND password = ?
  ''', [username, password]);

    if (res.isNotEmpty) {
      var firstResult = res.first;
      return User.fromMap({
        'user_id': firstResult['user_id'],
        'f_name': firstResult['f_name'],
        'l_name': firstResult['l_name'],
        'username': firstResult['username'],
        'password': firstResult['password'],
        'mobilehp': firstResult['mobilehp'],
      });
    }

    return null;
  }

  Future<bool> updateUser(User user) async {
    final db = await this.db;
    var data = user.toMap();
    try {
      await db.update(
        'user',
        data,
        where: 'user_id = ?',
        whereArgs: [user.userId],
      );
      return true;
    } catch (error) {
      print('Failed to update user: $error');
      return false;
    }
  }
}
