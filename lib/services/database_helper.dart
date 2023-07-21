import 'package:atom_cto_task/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DateBaseHelper {
  static const _databaseName = "AtomCTO.db";
  static const _databaseVersion = 1;

  static const table = 'tasks';

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
    await db.execute('''
          CREATE TABLE $table (
            ${Constants.id} INTEGER PRIMARY KEY,
            ${Constants.title} TEXT NOT NULL,
            ${Constants.description} TEXT NOT NULL,
            ${Constants.dueDate} TEXT NOT NULL,
            ${Constants.isCompleted} INTEGER NOT NULL
          )
          ''');
  }

  //Helper methods

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(
      {required int status, bool filterStatus = false}) async {
    if (filterStatus) {
      return await _db.query(
        table,
        where: '${Constants.isCompleted} = ?',
        whereArgs: [status],
      );
    } else {
      return await _db.query(
        table,
      );
    }
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[Constants.id];
    return await _db.update(
      table,
      row,
      where: '${Constants.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '${Constants.id} = ?',
      whereArgs: [id],
    );
  }
}
