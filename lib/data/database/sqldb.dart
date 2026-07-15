import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "notes_v3.db");
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE notes ADD COLUMN category TEXT');
      print("Upgraded database to version 2");
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "content" TEXT NOT NULL,
        "color" INTEGER NOT NULL,
        "isPinned" INTEGER NOT NULL DEFAULT 0,
        "isArchived" INTEGER NOT NULL DEFAULT 0,
        "category" TEXT,
        "createdAt" TEXT NOT NULL
      )
    ''');
    print("Create database and table ====================");
  }

  Future<List<NoteModel>> readAllNotes({bool includeArchived = false}) async {
    Database? mydb = await db;
    String? where = includeArchived ? null : 'isArchived = 0';
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: where,
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> insertNote(NoteModel note) async {
    Database? mydb = await db;
    int response = await mydb!.insert('notes', note.toMap());
    return response;
  }

  Future<int> updateNote(NoteModel note) async {
    Database? mydb = await db;
    int response = await mydb!.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    return response;
  }

  Future<int> deleteNote(int id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  Future<int> deleteAllNotes() async {
    Database? mydb = await db;
    int response = await mydb!.delete('notes');
    return response;
  }

  Future<List<NoteModel>> searchNotes(String query, {bool includeArchived = false}) async {
    Database? mydb = await db;
    String where = '(title LIKE ? OR content LIKE ?)';
    if (!includeArchived) {
      where += ' AND isArchived = 0';
    }
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: where,
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<List<NoteModel>> readArchivedNotes() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: 'isArchived = 1',
      orderBy: 'createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }
}
