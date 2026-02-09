import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reminder.dart';

class ReminderDatabase {
  static final ReminderDatabase instance = ReminderDatabase._();
  static Database? _database;

  ReminderDatabase._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'reminders.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dateTime TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Reminder reminder) async {
    final db = await database;
    return db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getAll() async {
    final db = await database;
    final result = await db.query(
      'reminders',
      orderBy: 'dateTime ASC',
    );

    return result.map(Reminder.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
