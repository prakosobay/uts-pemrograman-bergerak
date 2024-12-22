import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'password_manager.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullname TEXT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE passwords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            title TEXT,
            username TEXT,
            password TEXT,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');
      },
    );
  }
}
