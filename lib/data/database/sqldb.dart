import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

import '../models/category_model.dart';

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

  Future<Database> initialDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "notes_v5.db");
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE notes ADD COLUMN category TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE notes ADD COLUMN isDeleted INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE notes ADD COLUMN deletedAt TEXT');
      await db.execute('''
        CREATE TABLE "categories" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "name" TEXT NOT NULL,
          "color" INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE notes ADD COLUMN attachments TEXT');
      await db.execute('ALTER TABLE notes ADD COLUMN isLocked INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE notes ADD COLUMN reminderAt TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "content" TEXT NOT NULL,
        "color" INTEGER NOT NULL,
        "isPinned" INTEGER NOT NULL DEFAULT 0,
        "isArchived" INTEGER NOT NULL DEFAULT 0,
        "isDeleted" INTEGER NOT NULL DEFAULT 0,
        "deletedAt" TEXT,
        "category" TEXT,
        "attachments" TEXT,
        "isLocked" INTEGER NOT NULL DEFAULT 0,
        "reminderAt" TEXT,
        "createdAt" TEXT NOT NULL
      )
    ''');
    await db.execute('''
        CREATE TABLE "categories" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "name" TEXT NOT NULL,
          "color" INTEGER NOT NULL
        )
      ''');
  }

  Future<List<NoteModel>> readAllNotes({bool includeArchived = false}) async {
    Database? mydb = await db;
    String where = 'isDeleted = 0';
    if (!includeArchived) {
      where += ' AND isArchived = 0';
    }
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: where,
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }

  // ... rest of the file ...

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
    String where = '(title LIKE ? OR content LIKE ?) AND isDeleted = 0';
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
      where: 'isArchived = 1 AND isDeleted = 0',
      orderBy: 'createdAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<List<NoteModel>> readDeletedNotes() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'notes',
      where: 'isDeleted = 1',
      orderBy: 'deletedAt DESC',
    );
    return response.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> purgeDeletedNotes(int days) async {
    Database? mydb = await db;
    final threshold = DateTime.now().subtract(Duration(days: days));
    return await mydb!.delete(
      'notes',
      where: 'isDeleted = 1 AND deletedAt < ?',
      whereArgs: [threshold.toIso8601String()],
    );
  }

  // Category Methods
  Future<List<CategoryModel>> readAllCategories() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query('categories');
    return response.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> insertCategory(CategoryModel category) async {
    Database? mydb = await db;
    return await mydb!.insert('categories', category.toMap());
  }

  Future<int> deleteCategory(int id) async {
    Database? mydb = await db;
    return await mydb!.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
