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

  Future<Reminder?> getById(int id) async {
    final db = await database;
    final result = await db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return Reminder.fromMap(result.first);
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
    final rows = await db.query('reminders');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    int count = 0;

    for (final row in rows) {
      final reminder = Reminder.fromMap(row);
      final nextOccurrence = reminder.nextOccurrence;

      // Check if next occurrence is today
      if (nextOccurrence.isAfter(today.subtract(const Duration(seconds: 1))) &&
          nextOccurrence.isBefore(tomorrow)) {
        count++;
      }
    }

    return count;
  }

  Future<int> countThisWeek() async {
    final db = await database;
    final rows = await db.query('reminders');
    final now = DateTime.now();

    // Get start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    // Get end of week (Sunday)
    final endOfWeek = weekStart.add(const Duration(days: 7));

    int count = 0;

    for (final row in rows) {
      final reminder = Reminder.fromMap(row);
      final nextOccurrence = reminder.nextOccurrence;

      // Check if next occurrence is this week
      if (nextOccurrence.isAfter(
            weekStart.subtract(const Duration(seconds: 1)),
          ) &&
          nextOccurrence.isBefore(endOfWeek)) {
        count++;
      }
    }

    return count;
  }

  Future<int> countOverdue() async {
    final db = await database;
    final rows = await db.query('reminders');
    final now = DateTime.now();
    int count = 0;

    for (final row in rows) {
      final reminder = Reminder.fromMap(row);

      // Only "Once" type reminders can be overdue
      if (reminder.type == 'Once') {
        if (reminder.nextOccurrence.isBefore(now)) {
          count++;
        }
      }
    }

    return count;
  }
}
