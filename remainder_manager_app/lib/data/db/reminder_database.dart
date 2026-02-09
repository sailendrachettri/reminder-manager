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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT,
        weekday INTEGER,
        dayOfMonth INTEGER,
        month INTEGER
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
    final result = await db.query('reminders');

    return result.map(Reminder.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countAll() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM reminders');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<int> countToday() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T').first;

    final res = await db.rawQuery(
      'SELECT COUNT(*) as c FROM reminders WHERE date = ?',
      [today],
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<int> countThisWeek() async {
    final db = await database;
    final now = DateTime.now();

    final start = now
        .subtract(Duration(days: now.weekday - 1))
        .toIso8601String()
        .split('T')
        .first;
    final end = now
        .add(Duration(days: 7 - now.weekday))
        .toIso8601String()
        .split('T')
        .first;

    final res = await db.rawQuery(
      'SELECT COUNT(*) as c FROM reminders WHERE date BETWEEN ? AND ?',
      [start, end],
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<int> countOverdue() async {
    final db = await database;
    final rows = await db.query('reminders');

    final now = DateTime.now();

    int count = 0;
    for (final row in rows) {
      final reminder = Reminder.fromMap(row);
      if (reminder.effectiveDateTime.isBefore(now)) {
        count++;
      }
    }

    return count;
  }
}
