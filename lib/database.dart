import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const expenses = 'my_expenses';
  static const wants = 'my_wants';
  static const savings = 'my_savings';

  static const columnID = '_id';
  static const columnName = 'name';
  static const columnAmount = 'age';
  static const income = 'income';

  late Database _db;

  // This opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await _createTables(db);
  }

Future<void> _createTables(Database db) async {
  await db.execute('''
  CREATE TABLE $expenses (
    $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL,
    $columnAmount INTEGER PRIMARY KEY
  )
  ''');

  await db.execute('''
  CREATE TABLE $wants (
    $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL,
    $columnAmount INTEGER PRIMARY KEY
  )
  ''');

  await db.execute('''
  CREATE TABLE $savings (
    $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL,
    $columnAmount INTEGER PRIMARY KEY
  )
  ''');
}