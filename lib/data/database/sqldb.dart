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
    String path = join(databasePath, "notes_v2.db");
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "content" TEXT NOT NULL,
        "color" INTEGER NOT NULL,
        "isPinned" INTEGER NOT NULL DEFAULT 0,
        "createdAt" TEXT NOT NULL
      )
    ''');
    print("Create database and table ====================");
  }

  Future<List<NoteModel>> readAllNotes() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
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

  Future<List<NoteModel>> searchNotes(String query) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }
}
