import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const essentials = 'my_essentials';
  static const wants = 'my_wants';
  static const savings = 'my_savings';
  static const income = 'my_income';

  static const columnID = '_id';
  static const columnName = 'name';
  static const columnAmount = 'amount';


  late Database _db;

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
    CREATE TABLE $essentials (
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnAmount INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $wants (
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnAmount INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $savings (
      $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnAmount INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $income (
      $columnAmount INTEGER NOT NULL
    )
    ''');

  }

  Future<int> insertIncome(Map<String, dynamic> row) async {
    return await _db.insert(income, row);
  }

  Future<int> insertEssential(Map<String, dynamic> row) async {
    return await _db.insert(essentials, row);
  }

  Future<int> insertWants(Map<String, dynamic> row) async {
    return await _db.insert(wants, row);
  }

  Future<int> insertSavings(Map<String, dynamic> row) async {
    return await _db.insert(savings, row);
  }

  Future<int> deleteIncome(int id) async {
    return await _db.delete(
      income,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEssential(int id) async {
    return await _db.delete(
      essentials,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWants(int id) async {
    return await _db.delete(
      wants,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSavings(int id) async {
    return await _db.delete(
      savings,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryIncome() async {
    return await _db.query(income);
  }

  Future<List<Map<String, dynamic>>> queryEssentials() async {
    return await _db.query(essentials);
  }

  Future<List<Map<String, dynamic>>> queryWants() async {
    return await _db.query(wants);
  }

  Future<List<Map<String, dynamic>>> querySavings() async {
    return await _db.query(savings);
  }


  Future<int> sumEssentials() async {
    final List<Map<String, dynamic>> result = await _db.query(
      'essentials',
      columns: ['columnAmount'],
    );

    int E_total = result.fold(0, (sum, row) => sum + (row['columnAmount'] as int));

    return E_total;
  }

  Future<int> sumWants() async {
    final List<Map<String, dynamic>> result = await _db.query(
      'wants',
      columns: ['columnAmount'],
    );

    int W_total = result.fold(0, (sum, row) => sum + (row['columnAmount'] as int));

    return W_total;
  }

  Future<int> sumSavings() async {
    final List<Map<String, dynamic>> result = await _db.query(
      'savings',
      columns: ['columnAmount'],
    );

    int S_total = result.fold(0, (sum, row) => sum + (row['columnAmount'] as int));

    return S_total;
  }

  Future<int> sumIncome() async {
    final List<Map<String, dynamic>> result = await _db.query(
      'income',
      columns: ['columnAmount'],
    );

    int I_total = result.fold(0, (sum, row) => sum + (row['columnAmount'] as int));

    return I_total;
  }
}
